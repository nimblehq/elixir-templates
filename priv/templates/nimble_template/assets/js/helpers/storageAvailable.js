/**
 * @see https://developer.mozilla.org/en-US/docs/Web/API/Web_Storage_API/Using_the_Web_Storage_API
 */

const STORAGE_TYPES = {
  localStorage: "localStorage",
};

function isStorageAvailable(type) {
  let storage;
  try {
    storage = window[type];
    const x = "__storage_test__";
    storage.setItem(x, x);
    storage.removeItem(x);
    return true;
  } catch (e) {
    const isAvailable =
      e instanceof DOMException &&
      // everything except Firefox
      (e.code === 22 ||
        // Firefox
        e.code === 1014 ||
        // test name field too, because code might not be present
        // everything except Firefox
        e.name === "QuotaExceededError" ||
        // Firefox
        e.name === "NS_ERROR_DOM_QUOTA_REACHED") &&
      // acknowledge QuotaExceededError only if there's something already stored
      storage &&
      storage.length !== 0;

    if (!isAvailable) {
      // Track the error, eg: Sentry.captureMessage(`${type} isn't available`);
      console.error(`${type} isn't available`);
    }

    return isAvailable;
  }
}

function isLocalStorageAvailable() {
  isStorageAvailable(STORAGE_TYPES.localStorage);
}

export { isLocalStorageAvailable };
