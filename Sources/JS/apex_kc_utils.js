/*global window,apex*/
/**
 * This namespace holds
 * @namespace
 */
apex.kcUtils = {};
(function(apex, $, util, undefined) {
  "use strict";
  var self = util;
  self.functionLogger = {};
  self.excludedFunctions = {};

  self.functionLogger.log = true; //Set this to false to disable logging

  /**
   * After this is called, all direct children of the provided namespace object that are
   * functions will be added to exculded array and the log will not be hooked.
   *
   * @param namespaceObject The object whose child functions you'd like to not add logging to.
   *
   * @return A function that will perform logging and then call the function.
   */
  self.functionLogger.excludeLoggingToNamespace = function(namespaceObject) {
    for (var name in namespaceObject) {
      var potentialFunction = namespaceObject[name];

      if (Object.prototype.toString.call(potentialFunction) === '[object Function]') {
        self.excludedFunctions[name] = name;
      }
    }
  };

  /**
   * Gets a function that when called will log information about itself if logging is turned on.
   * // NOTE: This function will only log messages if the debug level is equal to LOG_LEVEL.APP_TRACE or bigger
   *
   * @param func The function to add logging to.
   * @param name The name of the function.
   *
   * @return A function that will perform logging and then call the function.
   */
  self.functionLogger.getLoggableFunction = function(func, name) {
    return function() {
      var logText = '(';
      console.groupCollapsed(name);
      var returnValue = func.apply(this, arguments);

      for (var i = 0; i < arguments.length; i++) {
        if (i > 0) {
          logText += ', ';
        }

        if (typeof arguments[i] !== 'string' || typeof arguments[i] !== 'number') {
          logText += self.customStringify(arguments[i]);
        } else {
          logText += arguments[i];
        }
      }
      logText += ');';

      var consoleTable = [{
        'Function name': name,
        'Function arguments': logText,
        'Returned Value': (typeof returnValue == 'boolean' || self.objExists(returnValue)) ? returnValue : 'No value returned or undefined!'
      }];

      console.table(consoleTable);
      console.groupEnd();
      return returnValue;
    }
  }

  /**
   * This function will only log messages if the debug level is equal to LOG_LEVEL.ENGINE_TRACE.
   *
   * @param func The function to add logging to.
   * @param name The name of the function.
   *
   * @return A function that will perform logging and then call the function.
   */
  self.functionLogger.LogTrace = function(pMessage, pTrace) {
    apex.debug.message(apex.debug.LOG_LEVEL.ENGINE_TRACE, pMessage);
  }

  /**
   * After this is called, all direct children of the provided namespace object that are
   * functions will log their name as well as the values of the parameters passed in.
   *
   * @param namespaceObject The object whose child functions you'd like to add logging to.
   */
  self.functionLogger.addLoggingToNamespace = function(namespaceObject) {
    for (var name in namespaceObject) {
      var potentialFunction = namespaceObject[name];
      if (Object.prototype.toString.call(potentialFunction) === '[object Function]' &&
        !self.excludedFunctions[name]) {
        namespaceObject[name] = self.functionLogger.getLoggableFunction(potentialFunction, name);
        self.excludedFunctions[name] = name;
      }
    }
  }
  /**
   * This function is used to check if an id is contained in array of objects.
   *
   * @param pArray The array of objects, the "members" are expected to have property named id.
   * @param pId    The id for which we will look in the array of objects to se if it exists.
   */
  self.isIdInArrayObj = function(pArray, pId) {
    var exists;
    for (var i = 0; i < pArray.length; i++) {
      if (pArray[i].id == pId) {
        exists = true;
        break;
      } else {
        exists = false;
      }
    }
    return exists;
  }
  /**
   * This function is used to check if a javascript object contains elements or is undefined.
   *
   * @param pObj The object, where the object can either be a string object or an array object etc.
   */
  self.objExists = function(pObj) {
    if(pObj == null){
      return false;
    }else if (typeof pObj === 'undefined') {
      return false;
    }
    return pObj.length > 0;
  }

  // Example to call var profiledMax = timeFunction(Math.max, 'Math.max');
  //profiledMax.call(Math, 1, 2);
  //Expected log => "Math.max took 2 ms to execute"
  self.timeFunction = function(func, funcName) {
    return function() {
      var start = new Date(),
        returnVal = func.apply(this, arguments),
        end = new Date(),
        duration = stop.getTime() - start.getTime();

      console.log(`${funcName} took ${duration} ms to execute`);
      return returnVal;
    };
  }

  self.customStringify = function(v) {
    const cache = new Set();
    return JSON.stringify(v, function(key, value) {
      if (typeof value === 'object' && value !== null) {
        if (cache.has(value)) {
          // Circular reference found
          try {
            // If this value does not reference a parent it can be deduped
            return JSON.parse(JSON.stringify(value));
          } catch (err) {
            // discard key if value cannot be deduped
            return;
          }
        }
        // Store value in our set
        cache.add(value);
      }
      return value;
    });
  };


})(apex, apex.jQuery, apex.kcUtils);
