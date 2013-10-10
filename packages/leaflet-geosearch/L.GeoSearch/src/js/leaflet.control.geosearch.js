var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

L.GeoSearch = {};

L.GeoSearch.Provider = {};

jQuery.support.cors = true;

L.GeoSearch.Result = function(x, y, label) {
  this.X = x;
  this.Y = y;
  return this.Label = label;
};

L.Control.GeoSearch = (function(_super) {
  __extends(GeoSearch, _super);

  GeoSearch.prototype.options = {
    position: "topleft",
    provider: null,
    searchLabel: "Enter address",
    notFoundMessage: "Sorry, that address could not be found.",
    zoomLevel: 17,
    showMarker: true,
    enableAutocomplete: true,
    autocompleteMinQueryLen: 3,
    autocompleteQueryDelay_ms: 800,
    maxResultCount: 10
  };

  function GeoSearch(options) {
    this._show = __bind(this._show, this);
    this._showLocation = __bind(this._showLocation, this);
    var _this = this;
    L.Util.extend(this.options, options);
    this.options.onMakeSuggestionHTML = function(geosearchResult) {
      return _this._htmlEscape(geosearchResult.Label);
    };
  }

  GeoSearch.prototype.onAdd = function(map) {
    var form, input,
      _this = this;
    this._container = L.DomUtil.create("div", "leaflet-bar leaflet-control leaflet-control-geosearch");
    this._btnSearch = L.DomUtil.create("a", "", this._container);
    this._btnSearch.href = "#";
    this._btnSearch.title = this.options.searchLabel;
    this._changeIcon("glass");
    form = L.DomUtil.create("form", "displayNone", this._container);
    form.setAttribute("autocomplete", "off");
    input = L.DomUtil.create("input", null, form);
    input.placeholder = this.options.searchLabel;
    input.setAttribute("id", "inputGeosearch");
    input.setAttribute("autocomplete", "off");
    this._searchInput = input;
    L.DomEvent.on(this._btnSearch, "click", L.DomEvent.stop).on(this._btnSearch, "click", function() {
      if (L.DomUtil.hasClass(form, "displayNone")) {
        L.DomUtil.removeClass(form, "displayNone");
        $(input).select();
        $(input).focus();
        return $(input).trigger("click");
      } else {
        return _this._hide();
      }
    });
    L.DomEvent.on(input, "keyup", this._onKeyUp, this).on(input, "keypress", this._onKeyPress, this).on(input, "input", this._onInput, this);
    if (L.Browser.touch) {
      L.DomEvent.on(this._container, "click", L.DomEvent.stop);
    } else {
      L.DomEvent.disableClickPropagation(this._container);
      L.DomEvent.on(this._container, "mousewheel", L.DomEvent.stop);
    }
    if (this.options.enableAutocomplete) {
      this._createSuggestionBox(this.container, "leaflet-geosearch-autocomplete");
      this._recordLastUserInput("");
      $(this._container).append(this._suggestionBox);
    }
    this._message = L.DomUtil.create("div", "leaflet-bar message displayNone", this._container);
    L.DomEvent.on(this._map, "click", (function() {
      return _this._hide();
    }));
    return this._container;
  };

  GeoSearch.prototype._createSuggestionBox = function(container, className) {
    var _this = this;
    this._suggestionBox = L.DomUtil.create("div", className, container);
    L.DomUtil.addClass(this._suggestionBox, "displayNone");
    L.DomEvent.disableClickPropagation(this._suggestionBox).on(this._suggestionBox, "blur", this._hide, this).on(this._suggestionBox, "mousewheel", function(e) {
      L.DomEvent.stopPropagation(e);
      if (e.axis === e.VERTICAL_AXIS) {
        if (e.detail > 0) {
          return _this._moveDown();
        } else {
          return _this._moveUp();
        }
      }
    });
    return this._suggestionBox;
  };

  GeoSearch.prototype._changeIcon = function(icon) {
    this._btnSearch = this._container.querySelector("a");
    return this._btnSearch.className = "leaflet-bar-part leaflet-bar-part-single" + " " + icon;
  };

  GeoSearch.prototype._geosearch = function(qry) {
    var error, provider, results, url,
      _this = this;
    try {
      provider = this.options.provider;
      if (typeof provider.GetLocations === "function") {
        return results = provider.GetLocations(qry, function(results) {
          return _this._processResults(results);
        });
      } else {
        url = provider.GetServiceUrl(qry);
        return $.getJSON(url, function(data) {
          var error;
          try {
            results = provider.ParseJSON(data);
            return _this._processResults(results);
          } catch (_error) {
            error = _error;
            return _this._printError(error);
          }
        });
      }
    } catch (_error) {
      error = _error;
      return this._printError(error);
    }
  };

  GeoSearch.prototype._geosearchAutocomplete = function(qry, requestDelay_ms) {
    var _this = this;
    if (!this.options.enableAutocomplete) {
      return;
    }
    clearTimeout(this._autocompleteRequestTimer);
    return this._autocompleteRequestTimer = setTimeout(function() {
      var q;
      q = qry;
      if (typeof qry === "function") {
        q = qry();
      }
      if (q.length >= _this.options.autocompleteMinQueryLen) {
        return _this._geosearch(q);
      } else {
        return _this._hide();
      }
    }, requestDelay_ms);
  };

  GeoSearch.prototype._processResults = function(results) {
    if (results.length === 0) {
      this._printError(this.options.notFoundMessage);
    } else {
      this._show(results);
      this._map.fireEvent('geosearch_foundlocations', {
        Location: location
      });
    }
    return results;
  };

  GeoSearch.prototype._showLocation = function(location) {
    location = location[0];
    if (this.options.showMarker) {
      if (typeof this._positionMarker === "undefined") {
        this._positionMarker = L.marker([location.Y, location.X]).addTo(this._map);
      } else {
        this._positionMarker.setLatLng([location.Y, location.X]);
      }
    }
    this._map.setView([location.Y, location.X], this.options.zoomLevel, false);
    this._map.fireEvent('geosearch_showlocation', {
      Location: location
    });
    return this._cancelSearch();
  };

  GeoSearch.prototype._isShowingError = false;

  GeoSearch.prototype._printError = function(error) {
    this._message.innerHTML = error;
    L.DomUtil.removeClass(this._message, "displayNone");
    this._changeIcon("alert");
    this._isShowingError = true;
    return this._hideAutocomplete();
  };

  GeoSearch.prototype._cancelSearch = function() {
    var input;
    input = this._container.querySelector("input");
    input.value = "";
    this._changeIcon("glass");
    return this._hide();
  };

  GeoSearch.prototype._startSearch = function() {
    var input, location;
    this._changeIcon("spinner");
    input = this._container.querySelector("input");
    location = this.options.provider.GetLocations(input.value, this._showLocation);
    return this._hide();
  };

  GeoSearch.prototype._recordLastUserInput = function(str) {
    return this._lastUserInput = str;
  };

  GeoSearch.prototype._show = function(results) {
    var count, entry;
    this._changeIcon("glass");
    this._suggestionBox.innerHTML = "";
    this._suggestionBox.currentSelection = -1;
    count = 0;
    while (count < results.length && count < this.options.maxResultCount) {
      entry = this._newSuggestion(results[count]);
      this._suggestionBox.appendChild(entry);
      ++count;
    }
    if (count > 0) {
      L.DomUtil.removeClass(this._suggestionBox, "displayNone");
    } else {
      this._hide();
    }
    return count;
  };

  GeoSearch.prototype._hideAutocomplete = function() {
    if (!L.DomUtil.hasClass(this._suggestionBox, "displayNone")) {
      L.DomUtil.addClass(this._suggestionBox, "displayNone");
    }
    return clearTimeout(this._autocompleteRequestTimer);
  };

  GeoSearch.prototype._hide = function() {
    var form;
    if (this.options.enableAutocomplete) {
      this._hideAutocomplete;
    }
    form = this._container.querySelector("form");
    if (!L.DomUtil.hasClass(form, "displayNone")) {
      L.DomUtil.addClass(form, "displayNone");
    }
    if (!L.DomUtil.hasClass(this._message, "displayNone")) {
      L.DomUtil.addClass(this._message, "displayNone");
    }
    return this._suggestionBox.innerHTML = "";
  };

  GeoSearch.prototype._isVisible = function() {
    return !L.DomUtil.hasClass(this._suggestionBox, "displayNone");
  };

  GeoSearch.prototype._htmlEscape = function(str) {
    return String(str).replace(/&/g, "&amp;").replace(/"/g, "&quot;").replace(/'/g, "&#39;").replace(/</g, "&lt;").replace(/>/g, "&gt;");
  };

  GeoSearch.prototype._newSuggestion = function(result) {
    var tip,
      _this = this;
    tip = L.DomUtil.create("li", "leaflet-geosearch-suggestion");
    tip.innerHTML = '<i class="leaflet-control-geosearch marker"></i>' + this.options.onMakeSuggestionHTML(result);
    tip._text = result.Label;
    L.DomEvent.disableClickPropagation(tip).on(tip, "click", function(e) {
      _this._onSelection(tip._text);
      return _this._startSearch();
    });
    return tip;
  };

  GeoSearch.prototype._onSelection = function(suggestionText) {
    return this._searchInput.value = suggestionText;
  };

  GeoSearch.prototype._onSelectedUpdate = function() {
    var entries, i, tipOffsetTop;
    entries = (this._suggestionBox.hasChildNodes() ? this._suggestionBox.childNodes : []);
    i = 0;
    while (i < entries.length) {
      L.DomUtil.removeClass(entries[i], "leaflet-geosearch-suggestion-selected");
      ++i;
    }
    if (this._suggestionBox.currentSelection >= 0) {
      L.DomUtil.addClass(entries[this._suggestionBox.currentSelection], "leaflet-geosearch-suggestion-selected");
      tipOffsetTop = entries[this._suggestionBox.currentSelection].offsetTop;
      if (tipOffsetTop + entries[this._suggestionBox.currentSelection].clientHeight >= this._suggestionBox.scrollTop + this._suggestionBox.clientHeight) {
        this._suggestionBox.scrollTop = tipOffsetTop - this._suggestionBox.clientHeight + entries[this._suggestionBox.currentSelection].clientHeight;
      } else {
        if (tipOffsetTop <= this._suggestionBox.scrollTop) {
          this._suggestionBox.scrollTop = tipOffsetTop;
        }
      }
      return this._onSelection(entries[this._suggestionBox.currentSelection]._text);
    } else {
      return this._onSelection(this._lastUserInput);
    }
  };

  GeoSearch.prototype._moveUp = function() {
    if (this._isVisible() && this._suggestionBox.currentSelection >= 0) {
      --this._suggestionBox.currentSelection;
      return this._onSelectedUpdate();
    }
  };

  GeoSearch.prototype._moveDown = function() {
    if (this._isVisible()) {
      this._suggestionBox.currentSelection = (this._suggestionBox.currentSelection + 1) % this._suggestionCount();
      return this._onSelectedUpdate();
    }
  };

  GeoSearch.prototype._suggestionCount = function() {
    if (this._suggestionBox.hasChildNodes()) {
      return this._suggestionBox.childNodes.length;
    } else {
      return 0;
    }
  };

  GeoSearch.prototype._onInput = function() {
    if (this._isShowingError) {
      this._changeIcon("glass");
      L.DomUtil.addClass(this._message, "displayNone");
      return this._isShowingError = false;
    }
  };

  GeoSearch.prototype._clearUserSearchInput = function() {
    this._searchInput.value = "";
    return this._hideAutocomplete();
  };

  GeoSearch.prototype._onChange = function() {
    var input, qry;
    if (this.options.enableAutocomplete) {
      input = this._container.querySelector("input");
      qry = input.value;
      this._recordLastUserInput(qry);
      if (qry.length >= this.options.autocompleteMinQueryLen) {
        this._changeIcon("spinner");
        return this._geosearchAutocomplete(qry, this.options.autocompleteQueryDelay_ms);
      } else {
        this._changeIcon("glass");
        return this._hideAutocomplete();
      }
    }
  };

  GeoSearch.prototype._onKeyPress = function(e) {
    var enterKey, escapeKey;
    enterKey = 13;
    escapeKey = 27;
    switch (e.keyCode) {
      case enterKey:
        L.DomEvent.preventDefault(e);
        return this._startSearch();
    }
  };

  GeoSearch.prototype._onKeyUp = function(e) {
    var downArrow, escapeKey, form, input, upArrow;
    upArrow = 38;
    downArrow = 40;
    escapeKey = 27;
    switch (e.keyCode) {
      case upArrow:
        if (this.options.enableAutocomplete && this._isVisible()) {
          return this._moveUp();
        }
        break;
      case downArrow:
        if (this.options.enableAutocomplete && this._isVisible()) {
          return this._moveDown();
        }
        break;
      case escapeKey:
        input = this._container.querySelector("input");
        if (this._isVisible()) {
          return this._hideAutocomplete();
        } else {
          form = this._container.querySelector("form");
          if (!L.DomUtil.hasClass(form, "displayNone")) {
            L.DomUtil.addClass(form, "displayNone");
          }
          this._onInput();
          return this._hide();
        }
        break;
      default:
        return this._onChange();
    }
  };

  return GeoSearch;

})(L.Control);

/*
//@ sourceMappingURL=leaflet.control.geosearch.js.map
*/