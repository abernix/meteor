import { execFile } from 'child_process';
import Client from '../client.js';
import { enterJob } from '../../utils/buildmessage.js';
import { ensureDependencies } from '../../cli/dev-bundle-helpers.js';
import {
  convertToOSPath,
  pathJoin,
  getCurrentToolsDir,
} from '../../fs/files.js';

const NPM_DEPENDENCIES = {
  'chrome-launcher': '0.4.0',
};

let chromeLauncherPromise;
let chrome;

// PhantomClient
export default class ChromeClient extends Client {
  constructor(options) {
    super(options);

    enterJob({
      title: 'Installing Chrome helpers in Meteor tool',
    }, () => {
      ensureDependencies(NPM_DEPENDENCIES);
    });

    this.npmExportsChromeLauncher = require('chrome-launcher');

    this.name = "chrome-headless";
    this.process = null;

    this._logError = true;

    console.log("It's been initiated");
  }

  ensureChromeStarted() {
    console.log("Trying to start Chrome");
    if (!chromeLauncherPromise) {
      chromeLauncherPromise =
        this.npmExportsChromeLauncher.launch({
          chromeFlags: ['--headless', '--disable-gpu'],
        });
    }

    return chromeLauncherPromise.then((launchedChrome) => {
      console.log(`Chrome debugging port running on ${launchedChrome.port}`);
      chrome = launchedChrome;
    });
  }

  connect() {
    // ok
    console.log("The Chrome connect method has been called.");
    this.ensureChromeStarted();
  }

  stop() {
    // Suppress the expected SIGTERM exit 'failure'
    this._logError = false;
    if (this.chrome) {
      chrome.kill();
    }
    // this.process && this.process.kill();
    this.process = null;
  }
}
