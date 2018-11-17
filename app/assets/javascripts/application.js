// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require jquery.remotipart
//= require jquery-ui
//= require lightgallery-all
//= require autocomplete-rails
//= require tinymce
//= require jquery-fileupload/basic
//= require sweetalert.min
//= require tether
//= require social-share-button
//= require_directory .

$(function(){
  tinyMCE.init({
    selector: 'textarea',
    menubar: false,
    height: 400,
    toolbar: 'bold italic | alignleft aligncenter alignright alignjustify | bullist numlist outdent indent | link image',
    plugins: ['placeholder, link, wordcount']
  });

  $('.popup').click(function() {
      centerPopup($(this).attr('href'), $(this).attr('data-width'), $(this).attr('data-height'));
      return false;
  });

  $('body').on($.modal.AFTER_CLOSE, function(event, modal) {
    tinyMCE.remove();
    $('.token-input-dropdown-facebook').remove();
    $('.modal').remove();
  })
});

function centerPopup(linkUrl, width, height) {
    var sep = (linkUrl.indexOf('?') !== -1) ? '&' : '?',
        url = linkUrl + sep + 'popup=true',
        left = (screen.width - width) / 2 - 16,
        top = (screen.height - height) / 2 - 50,
        windowFeatures = 'menubar=no,toolbar=no,location=no,status=no,width=' + width +
            ',height=' + height + ',left=' + left + ',top=' + top;
    return window.open(url, 'authPopup', windowFeatures);
}

function deletePic(id){
  $.ajax({
    url: '/gallery_photos/'+id,
    type: 'DELETE',
    dataType: 'script'
  });
}

NProgress.configure({
  showSpinner: true,
  ease: 'ease',
  speed: 500
});
