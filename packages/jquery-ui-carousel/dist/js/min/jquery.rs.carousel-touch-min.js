/*! jquery.rs.carousel-min.js | 1.0.2 | 2013-06-22 | http://richardscarrott.github.com/jquery-ui-carousel/ */
!function(a){"use strict";var b=a.Widget.prototype;a.widget("rs.draggable3d",{options:{axis:"x",translate3d:!1},_create:function(){this.eventNamespace=this.eventNamespace||"."+this.widgetName,this._bindDragEvents()},_bindDragEvents:function(){var a=this,b=this.eventNamespace;this.element.unbind(b).bind("dragstart"+b,{axis:this.options.axis},function(b){a._start(b)}).bind("drag"+b,function(b){a._drag(b)}).bind("dragend"+b,function(b){a._end(b)})},_getPosStr:function(){return"x"===this.options.axis?"left":"top"},_start:function(a){this.mouseStartPos="x"===this.options.axis?a.pageX:a.pageY,this.elPos=this.options.translate3d?this.element.css("translate3d")[this.options.axis]:parseInt(this.element.position()[this._getPosStr()],10),this._trigger("start",a)},_drag:function(a){var b="x"===this.options.axis?a.pageX:a.pageY,c=b-this.mouseStartPos+this.elPos,d={};this.options.translate3d?d.translate3d="x"===this.options.axis?{x:c}:{y:c}:d[this._getPosStr()]=c,this.element.css(d)},_end:function(a){this._trigger("stop",a)},_setOption:function(a){b._setOption.apply(this,arguments),"axis"===a&&this._bindDragEvents()},destroy:function(){var a={};this.options.translate3d?a.translate3d={}:a[this._getPosStr()]="",this.element.css(a),b.destroy.apply(this)}})}(jQuery),function(a){"use strict";var b=a.rs.carousel.prototype;a.widget("rs.carousel",a.rs.carousel,{options:{touch:!1,sensitivity:1},_create:function(){b._create.apply(this),this._initDrag()},_initDrag:function(){var a=this;this.elements.runner.draggable3d({translate3d:this.options.translate3d,axis:this._getAxis(),start:function(b){b=b.originalEvent.touches?b.originalEvent.touches[0]:b,a._dragStartHandler(b)},stop:function(b){b=b.originalEvent.touches?b.originalEvent.touches[0]:b,a._dragStopHandler(b)}})},_destroyDrag:function(){this.elements.runner.draggable3d("destroy"),this.goToPage(this.index,!1,void 0,!0)},_getAxis:function(){return this.isHorizontal?"x":"y"},_dragStartHandler:function(a){this.options.translate3d&&this.elements.runner.removeClass(this.widgetFullName+"-runner-transition"),this.startTime=this._getTime(),this.startPos={x:a.pageX,y:a.pageY}},_dragStopHandler:function(a){var b,c,d,e,f=this._getAxis();this.endTime=this._getTime(),b=this.endTime-this.startTime,this.endPos={x:a.pageX,y:a.pageY},c=Math.abs(this.startPos[f]-this.endPos[f]),d=c/b,e=this.startPos[f]>this.endPos[f]?"next":"prev",d>this.options.sensitivity||c>this._getMaskDim()/2?this.index===this.getNoOfPages()-1&&"next"===e||0===this.index&&"prev"===e?this.goToPage(this.index):this[e]():this.goToPage(this.index)},_getTime:function(){var a=new Date;return a.getTime()},_setOption:function(a,c){switch(b._setOption.apply(this,arguments),a){case"orientation":this._switchAxis();break;case"touch":c?this._initDrag():this._destroyDrag()}},_switchAxis:function(){this.elements.runner.draggable3d("option","axis",this._getAxis())},destroy:function(){this._destroyDrag(),b.destroy.apply(this)}})}(jQuery);