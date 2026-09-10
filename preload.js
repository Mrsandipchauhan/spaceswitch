const { contextBridge, ipcRenderer } = require('electron');

contextBridge.exposeInMainWorld('electronAPI', {
  saveState: (state) => ipcRenderer.send('spaceswitch:saveState', state),
  loadState: () => ipcRenderer.invoke('spaceswitch:loadState'),
  onRestoreState: (callback) => ipcRenderer.on('spaceswitch:restoreState', (event, data) => callback(data))
});
