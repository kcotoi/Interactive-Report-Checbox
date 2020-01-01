/*global window,apex*/
apex.kcUtils.irCheckbox = {};
apex.kcUtils.irCheckbox.options = [];
(function(options, irCk, util, info, $, da, server, region, undefined) {
  "use strict";
  var gCheckedRecordsArray = [],
    gReportFilters = [],
    RENDER_CHECKBOX = 'RENDER_CHECKBOX',
    SUBMIT_CHECKBOX = 'SUBMIT_CHECKBOX',
    CLEAR_CHECKBOX = 'CLEAR_CHECKBOX';

  irCk.init = function() {
    irCk.reportId = '#' + this.triggeringElement.id;
    options[irCk.reportId] = {};
    options[irCk.reportId].context = this;
    options[irCk.reportId].resumeCallback = this.resumeCallback;
    options[irCk.reportId].refreshReport = this.action.attribute06;
    options[irCk.reportId].checkBoxColumnId = this.action.attribute02;
    options[irCk.reportId].rowSelectionEnabled = this.action.attribute07;
    options[irCk.reportId].ajax = {
      id: this.action.ajaxIdentifier,
      running: false,
      type: RENDER_CHECKBOX
    };
    options[irCk.reportId].pageItems = this.action.attribute08;

    info('Init Interactive Report Checbox for Report with Static ID "' + irCk.reportId + '"!');

    if (this.browserEvent == 'load') {

      if (!irCk.irHasMultipleViews()) {
        irCk.handleLoadEvent();
      }

    } else { //Should be click event

      if (!irCk.irHasMultipleViews()) {
        irCk.handleClickEvent();
      }
    }
  }

  irCk.getAllCheckboxes = function() {
    return $(irCk.reportId).find("td[headers*=" + options[irCk.reportId].checkBoxColumnId + "] input");
  }

  irCk.getCheckboxElement = function(pElement) {
    var lCheckBoxElement,
      lEventTargetElement = $(options[irCk.reportId].context.browserEvent.target);

    if (lEventTargetElement[0].nodeName == "INPUT") {
      lCheckBoxElement = lEventTargetElement;
    } else {
      lCheckBoxElement = pElement.find('input');
    }
    return lCheckBoxElement;
  }

  irCk.getReportFilters = function() {
    return $(irCk.reportId).find('ul.a-IRR-controls').find('span[id*="control_text"]');
  }

  irCk.checkIfFiltersAreTheSame = function(pPrevFilters, pNewFilters) {
    var filtersAreSame = true,
      prevFiltersArr = [],
      newFiltersArr = [];

    //if (util.objExists(pPrevFilters) && util.objExists(pNewFilters)) {
    pPrevFilters.each(function() {
      prevFiltersArr.push(this.textContent);
    });
    pNewFilters.each(function() {
      newFiltersArr.push(this.textContent);
    })
    //}

    if (JSON.stringify(prevFiltersArr) !== JSON.stringify(newFiltersArr)) {
      filtersAreSame = false;

    }
    return filtersAreSame;
  }

  irCk.updateCheckedRecordsArray = function(pRecordId, pChecked) {
    var record = {};
    record.id = pRecordId;

    if (pChecked && !util.isIdInArrayObj(gCheckedRecordsArray[irCk.reportId], record.id)) {

      gCheckedRecordsArray[irCk.reportId].push(record);
      info("irCk.updateCheckedRecordsArray -> Record Added: ", record);

    } else if (!pChecked) {

      gCheckedRecordsArray[irCk.reportId] = jQuery.grep(gCheckedRecordsArray[irCk.reportId], function(pRecord) {
        return pRecord.id != record.id;
      });
      info("irCk.updateCheckedRecordsArray -> Record Removed: ", record);
    }
  }

  irCk.updateStateOfAllChecboxes = function(pChecked) {

    irCk.getAllCheckboxes().each(function() {
      this.checked = pChecked;
      irCk.updateCheckedRecordsArray(this.value, pChecked);
    });

  }

  irCk.updateStateOfCheckboxHeader = function(pState) {
    var checkboxAllHeader = $(irCk.reportId).find("th#" + options[irCk.reportId].checkBoxColumnId),
      allCheckboxes = irCk.getAllCheckboxes();

    if (util.objExists(pState) && util.objExists(checkboxAllHeader)) {

      info("irCk.updateStateOfCheckboxHeader -> checkboxAllHeader exists , so we will set checkboxAllHeader to ", pState);
      checkboxAllHeader.find('input')[0].checked = pState;

    } else {

      if (util.objExists(allCheckboxes)) {
        var allCheckboxesChecked = (allCheckboxes.length === allCheckboxes.filter(":checked").length);
        info("irCk.updateStateOfCheckboxHeader -> allCheckboxesChecked: ", allCheckboxesChecked);

        if (util.objExists(checkboxAllHeader)) {
          info("irCk.updateStateOfCheckboxHeader -> checkboxAllHeader exists , so we will set checkboxAllHeader to ", allCheckboxesChecked);
          checkboxAllHeader.find('input')[0].checked = allCheckboxesChecked;
        }
      }
    }
    // trigger this to force Interactive report to resize its column headers
    $(window).trigger("apexwindowresized");
  }

  irCk.updateStateOfCheckbox = function(pCheckboxElement) {
    var lChecked = pCheckboxElement[0].checked,
      lEvent = options[irCk.reportId].context.browserEvent;

    if ($(lEvent.target)[0].nodeName !== "INPUT") {
      info("irCk.updateStateOfCheckbox -> Target Element not input so we check input here ! $(lEvent.target): ", $(lEvent.target));
      // only do this if the click was not on the checkbox,
      // because the checkbox will check itself
      lChecked = pCheckboxElement[0].checked = !lChecked;
    }
    return lChecked;
  }

  irCk.createCheckbox = function(pValue) {
    var checkbox = document.createElement('input');
    checkbox.type = "checkbox";
    checkbox.value = pValue;
    return checkbox;
  }

  irCk.renderSelections = function() {
    var allCheckboxes = irCk.getAllCheckboxes();
    info("irCk.renderSelections -> We will render selection for all Checkboxes: ", allCheckboxes);

    if (util.objExists(gCheckedRecordsArray[irCk.reportId])) {
      info('irCk.renderSelections -> Array with checked records for report ' + irCk.reportId + ' exists so we will check all records that are inside !');
      allCheckboxes.each(function() {
        var checkboxElement = this,
          recordIr = {};
        recordIr.id = checkboxElement.value;
        checkboxElement.checked = util.isIdInArrayObj(gCheckedRecordsArray[irCk.reportId], recordIr.id);
      });
    } else {
      info('irCk.renderSelections -> Array with checked records for report ' + irCk.reportId + ' does not exist so we will not render any selections!');
    }
    irCk.updateStateOfCheckboxHeader();
  }

  irCk.renderCheckboxes = function(pRenderSelections) {
    var colHeader = $(irCk.reportId).find("th#" + options[irCk.reportId].checkBoxColumnId),
      allCells = $(irCk.reportId).find("td[headers*=" + options[irCk.reportId].checkBoxColumnId + "]");
    info('irCk.renderCheckboxes -> We will render checboxes for column "' + options[irCk.reportId].checkBoxColumnId + '"!');

    if (util.objExists(colHeader)) {
      var checkbox = irCk.createCheckbox('all');

      info('irCk.renderCheckboxes -> Target column header with Static ID "' + options[irCk.reportId].checkBoxColumnId + '" found and we will render checkbox!');

      colHeader.find("span").empty().append(checkbox);

    } else {
      apex.debug.error('irCk.renderCheckboxes -> Target column header with Static ID "' + options[irCk.reportId].checkBoxColumnId + '" not found!');
    }

    if (util.objExists(allCells)) {
      info('irCk.renderCheckboxes -> Target column cells with Static ID "' + options[irCk.reportId].checkBoxColumnId + '" found and we will render checkboxes!');

      allCells.each(function() {
        var value = this.textContent;
        if (!this.className.includes('aggregate')) {
          $(this).empty().append(irCk.createCheckbox(value));
        }
      });

      if (pRenderSelections) {
        irCk.renderSelections();
      }
    } else {
      apex.debug.error('irCk.renderCheckboxes -> Target column cells with Static ID "' + options[irCk.reportId].checkBoxColumnId + '" not found!');

    }
    // trigger this to force Interactive report to resize its column headers
    $(window).trigger("apexwindowresized");
  }

  irCk.doAjax = function(pActionType, pAsync) {
    options[irCk.reportId].ajax.type = pActionType;

    var pAjaxCallbackName = options[irCk.reportId].ajax.id,
      pData = {
        p_clob_01: JSON.stringify(gCheckedRecordsArray[irCk.reportId]),
        x01: pActionType
      },
      pOptions;

    pOptions = {
      success: irCk.ajaxSuccess,
      error: irCk.ajaxError,
      async: pAsync
    };

    if (!options[irCk.reportId].ajax.running) {

      options[irCk.reportId].ajax.running = true;

      apex.server.plugin(pAjaxCallbackName, pData, pOptions);
    }

  }

  irCk.ajaxSuccess = function(pData, pTextStatus, pJqXHR) {
    info("irCk.ajaxSuccess ajax.type: ", options[irCk.reportId].ajax.type);

    if (options[irCk.reportId].ajax.type == SUBMIT_CHECKBOX) {

      apex.event.trigger(irCk.reportId, 'ir_selection_changed');

    } else if (options[irCk.reportId].ajax.type == RENDER_CHECKBOX) {

      gCheckedRecordsArray[irCk.reportId] = pData;

      if (irCk.hasReportData()) {
        irCk.renderCheckboxes(true);
      }

    } else if (options[irCk.reportId].ajax.type == CLEAR_CHECKBOX) {

      gCheckedRecordsArray[irCk.reportId] = [];

      if (options[irCk.reportId].refreshReport == 'Y') {
        $(irCk.reportId).trigger('apexrefresh');
      } else if (irCk.hasReportData()) {
        irCk.updateStateOfCheckboxHeader(false);
        irCk.updateStateOfAllChecboxes(false);
      }
      apex.event.trigger(irCk.reportId, 'ir_selection_changed');
    }
    /* Resume execution of actions here and pass false to the callback, to indicate no
    error has occurred. */
    da.resume(options[irCk.reportId].resumeCallback, false);
    options[irCk.reportId].ajax.running = false;
  }

  irCk.ajaxError = function(pData, pTextStatus, pJqXHR) {
    options[irCk.reportId].ajax.running = false;
    da.handleAjaxErrors(pJqXHR, pTextStatus, pData.errorMessage, options[irCk.reportId].resumeCallback);
  }

  irCk.irHasMultipleViews = function() {
    var views = $(irCk.reportId).find('div.a-IRR-controlGroup--views')[0],
      state = false;
    if (util.objExists()) {
      if (views.childElementCount > 0) {
        info("irCk.irHasMultipleViews -> We have multiple views for report : " + irCk.reportId + ", this means that pivot,chart or group by view is enabled so we will not render checkboxes.");
        state = true;
      }
    }
    info("irCk.irHasMultipleViews -> We don't have multiple views for report : " + irCk.reportId + ",  we will render checkboxes.");
    return state;
  }

  irCk.hasReportData = function() {
    var hasData = true,
      noDataFoundDIV = $(irCk.reportId).find('div.a-IRR-noDataMsg');
    if (util.objExists(noDataFoundDIV)) {
      hasData = false;
    }
    return hasData;
  }

  irCk.handleReportRefresh = function() {
    info("irCk.handleReportRefresh of Report : " + irCk.reportId);
    if (!irCk.irHasMultipleViews() && irCk.hasReportData()) {
      var filters = irCk.getReportFilters(),
        filtersAreSame = irCk.checkIfFiltersAreTheSame(gReportFilters[irCk.reportId], filters);

      irCk.renderCheckboxes(filtersAreSame);

      if (!filtersAreSame) {
        gReportFilters[irCk.reportId] = filters;
        irCk.clearCheckedRecordsArrayAjax('internal');
      }
    }
  }

  irCk.setReportIdToItems = function(pItems) {
    var lAffectedItemsArray;
    if (util.objExists(pItems)) {

      lAffectedItemsArray = pItems.split(",");
      for (var i = 0; i < lAffectedItemsArray.length; i++) {
        $('#' + lAffectedItemsArray[i])[0].setAttribute("data-report-id", irCk.reportId);
      }
    }
  }

  irCk.handleLoadEvent = function() {

    irCk.doAjax(RENDER_CHECKBOX, false);

    gReportFilters[irCk.reportId] = irCk.getReportFilters();

    $(options[irCk.reportId].context.triggeringElement).on("apexafterrefresh", function() {
      irCk.reportId = '#' + this.id; //pOptions.refreshObject[0].id;
      irCk.handleReportRefresh();
    });

    irCk.setReportIdToItems(options[irCk.reportId].pageItems);

  }

  irCk.handleClickEvent = function() {
    var lEvent = options[irCk.reportId].context.browserEvent,
      lCheckboxColHeaderEl = $(lEvent.target).closest("th#" + options[irCk.reportId].checkBoxColumnId),
      lCheckBoxElement,
      lChecked,
      lTrigerringRowElement = $(lEvent.target).closest('tr');

    if (irCk.hasReportData()) {
      if (util.objExists(lCheckboxColHeaderEl)) {
        info("irCk.handleClickEvent -> Checkbox column header Trigerred the event !");
        lCheckBoxElement = irCk.getCheckboxElement(lCheckboxColHeaderEl);

        if (util.objExists(lCheckBoxElement)) {

          lChecked = irCk.updateStateOfCheckbox(lCheckBoxElement);

          irCk.updateStateOfAllChecboxes(lChecked);

          irCk.doAjax(SUBMIT_CHECKBOX, true);

        }
      } else if (util.objExists(lTrigerringRowElement)) {

        if (options[irCk.reportId].rowSelectionEnabled == 'Y') {
          lCheckBoxElement = lTrigerringRowElement.find("td[headers*=" + options[irCk.reportId].checkBoxColumnId + "] input");
          info("irCk.handleClickEvent -> Row selection is enabled, so we got element from triggering row ! Element : " + lCheckBoxElement);
        } else {
          lCheckBoxElement = irCk.getCheckboxElement($(lEvent.target));
          info("irCk.handleClickEvent -> Row selection is not enabled, so we only get the checkbox element only if the click is on the checkbox cell itself ! Element : " + lCheckBoxElement);
        }
        if (util.objExists(lCheckBoxElement)) {

          lChecked = irCk.updateStateOfCheckbox(lCheckBoxElement);

          irCk.updateCheckedRecordsArray(lCheckBoxElement.val(), lChecked);

          irCk.doAjax(SUBMIT_CHECKBOX, true);

          irCk.updateStateOfCheckboxHeader();

        }
      }
    }

  }

  irCk.clearCheckedRecordsArrayAjax = function(pSource, pTriggeringItem) {
    if (pSource == 'item') {
      if (util.objExists($(pTriggeringItem))) {
        irCk.reportId = pTriggeringItem.dataset.reportId;
        irCk.doAjax(CLEAR_CHECKBOX, false);
      }
    } else if (pSource == 'internal') {
      irCk.doAjax(CLEAR_CHECKBOX, false);
    }
  }

  if (apex.debug.LOG_LEVEL.APP_TRACE <= apex.debug.getLevel()) {
    util.functionLogger.addLoggingToNamespace(irCk);
  }
})(apex.kcUtils.irCheckbox.options, apex.kcUtils.irCheckbox, apex.kcUtils, apex.debug.info, apex.jQuery, apex.da, apex.server, apex.region);
