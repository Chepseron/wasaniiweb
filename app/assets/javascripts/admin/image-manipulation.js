$(function(){
  $('.editable').mouseover(function() {
    $('.edit-overlay').show()
  })
  .mouseout(function() {
    $('.edit-overlay').hide()
  });

  $('#save-btn').hide();

  $("#user_profile_image, #artist_profile_pic, #business_logo, #award_image").change(function(){
      readURL(this);
  });

  function readURL(input) {
    if (input.files && input.files[0]) {
      var reader = new FileReader();
      reader.onload = function (e) {
        var image = new Image();
        image.src = e.target.result;

        $('#profile-pic').attr('src', e.target.result);
        $('#save-btn').show();
      }
      reader.readAsDataURL(input.files[0]);
    }
  }
});


