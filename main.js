const { app, BrowserWindow, Tray, Menu, ipcMain, powerMonitor, globalShortcut } = require('electron');
const path = require('path');
const fs = require('fs');

let mainWindow = null;
let tray = null;

// Config file path for macOS persistent state (~/.config/SpaceSwitch/session.json)
const configDir = path.join(app.getPath('userData'), 'SpaceSwitchConfig');
const stateFilePath = path.join(configDir, 'session_state.json');

function ensureConfigDir() {
  if (!fs.existsSync(configDir)) {
    fs.mkdirSync(configDir, { recursive: true });
  }
}

function saveStateToFile(state) {
  try {
    ensureConfigDir();
    fs.writeFileSync(stateFilePath, JSON.stringify(state, null, 2));
    console.log('[SpaceSwitch] State persisted to:', stateFilePath);
  } catch (err) {
    console.error('[SpaceSwitch] Error saving state:', err);
  }
}

function loadStateFromFile() {
  try {
    if (fs.existsSync(stateFilePath)) {
      const data = fs.readFileSync(stateFilePath, 'utf-8');
      return JSON.parse(data);
    }
  } catch (err) {
    console.error('[SpaceSwitch] Error loading state:', err);
  }
  return null;
}

function createWindow() {
  mainWindow = new BrowserWindow({
    width: 1280,
    height: 800,
    minWidth: 1000,
    minHeight: 650,
    titleBarStyle: 'hiddenInset',
    vibrancy: 'sidebar',
    visualEffectState: 'active',
    webPreferences: {
      preload: path.join(__dirname, 'preload.js'),
      nodeIntegration: false,
      contextIsolation: true
    }
  });

  mainWindow.loadFile('index.html');

  // Handle window close -> keep daemon running in macOS Menu Bar
  mainWindow.on('close', (e) => {
    if (!app.isQuitting) {
      e.preventDefault();
      mainWindow.hide();
    }
    return false;
  });
}

function createTray() {
  // Native macOS Menu Bar item setup
  const iconPath = path.join(__dirname, 'icon.png');
  tray = new Tray(fs.existsSync(iconPath) ? iconPath : path.join(__dirname, 'index.html'));
  tray.setToolTip('SpaceSwitch — Workspace Switcher');

  const contextMenu = Menu.buildFromTemplate([
    { label: 'SpaceSwitch Active', enabled: false },
    { type: 'separator' },
    { label: 'Workspace_1 (Work)', type: 'radio', checked: true, click: () => switchWorkspaceProfile('work') },
    { label: 'Personal (Home)', type: 'radio', click: () => switchWorkspaceProfile('personal') },
    { label: 'Design Studio', type: 'radio', click: () => switchWorkspaceProfile('design') },
    { label: 'DevOps & Infra', type: 'radio', click: () => switchWorkspaceProfile('devops') },
    { label: 'Email & Admin', type: 'radio', click: () => switchWorkspaceProfile('email') },
    { type: 'separator' },
    { label: 'Open SpaceSwitch', click: () => { mainWindow.show(); mainWindow.focus(); } },
    { label: 'Quit SpaceSwitch', click: () => { app.isQuitting = true; app.quit(); } }
  ]);

  tray.setContextMenu(contextMenu);
}

function switchWorkspaceProfile(profileKey) {
  if (mainWindow) {
    mainWindow.webContents.send('spaceswitch:restoreState', { activeProfile: profileKey });
  }
}

// macOS Launch at Login configuration
function setupLaunchAtLogin() {
  app.setLoginItemSettings({
    openAtLogin: true,
    openAsHidden: true,
    name: 'SpaceSwitch'
  });
}

// macOS System PowerMonitor Events (Shutdown, Suspend/Sleep, Wake/Resume)
function setupPowerMonitor() {
  powerMonitor.on('suspend', () => {
    console.log('[SpaceSwitch] macOS entering sleep/lid close. Saving workspace state...');
    if (mainWindow) {
      mainWindow.webContents.send('spaceswitch:requestSaveState');
    }
  });

  powerMonitor.on('resume', () => {
    console.log('[SpaceSwitch] macOS woke up. Restoring active workspace layout...');
    if (mainWindow) {
      const state = loadStateFromFile();
      if (state) mainWindow.webContents.send('spaceswitch:restoreState', state);
    }
  });

  powerMonitor.on('shutdown', () => {
    console.log('[SpaceSwitch] macOS shutting down. Snapshotting session state...');
    if (mainWindow) {
      mainWindow.webContents.send('spaceswitch:requestSaveState');
    }
  });
}

// IPC Handlers
ipcMain.on('spaceswitch:saveState', (event, state) => {
  saveStateToFile(state);
});

ipcMain.handle('spaceswitch:loadState', () => {
  return loadStateFromFile();
});

app.whenReady().then(() => {
  setupLaunchAtLogin();
  createWindow();
  createTray();
  setupPowerMonitor();

  // Register macOS global shortcuts (e.g. Option+Control+1..5)
  globalShortcut.register('Option+Control+1', () => switchWorkspaceProfile('work'));
  globalShortcut.register('Option+Control+2', () => switchWorkspaceProfile('personal'));
  globalShortcut.register('Option+Control+3', () => switchWorkspaceProfile('design'));

  app.on('activate', () => {
    if (BrowserWindow.getAllWindows().length === 0) createWindow();
    else mainWindow.show();
  });
});

app.on('before-quit', () => {
  app.isQuitting = true;
});

app.on('window-all-closed', () => {
  if (process.platform !== 'darwin') app.quit();
});
