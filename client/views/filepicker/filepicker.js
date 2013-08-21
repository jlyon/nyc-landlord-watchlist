
Template.filepicker.rendered = function () {
  filepicker.pickAndStore({
      mimetypes: ['image/*', '', 'text/plain'],
      container: 'filepicker-media-area'
    },
    {},
    function(InkBlob){
      console.log(this)
      console.log(JSON.stringify(InkBlob));
    },
    function(FPError){
      console.log(FPError.toString());
    }
  );

  /*filepicker.constructWidget(document.getElementById('attachment'));
  filepicker.makeDropPane($('#exampleDropPane')[0], {
    multiple: true,
    dragEnter: function() {
        $("#exampleDropPane").html("Drop to upload").css({
            'backgroundColor': "#E0E0E0",
            'border': "1px solid #000"
        });
    },
    dragLeave: function() {
        $("#exampleDropPane").html("Drop files here").css({
            'backgroundColor': "#F6F6F6",
            'border': "1px dashed #666"
        });
    },
    onSuccess: filepickerPick,
    onError: function(type, message) {
        $("#localDropResult").text('('+type+') '+ message);
    },
    onProgress: function(percentage) {
        $("#exampleDropPane").text("Uploading ("+percentage+"%)");
    }
  });*/
};



Template.filepicker.events({
  'click #fpPick' : function () {
    filepicker.pickMult(
      {
        mimetypes: ['image/*', 'text/plain'],
        container: 'window',
        services:['COMPUTER', 'FACEBOOK', 'GMAIL']
      },
      filepickerPick,
      filepickerError
    );
  }
});


// Callback after a successful upload
function filepickerPick(files) {
  Meteor.post
  console.log(files);

  for (var i in files) {
    var file = files[i];
    var doc = {
      file: file.key,
      title: file.filename,
      source: 'upload',
      status: 'reading'
    }
    Meteor.call('newDoc', doc, function(){});
  }
}


// Generic filepicker error handler
// @todo implement
function filepickerError(FPError) {
  console.log(FPError.toString());
}