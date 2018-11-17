
// humbeger menu
$(document).ready(function(){
  $('#navigation-toggle').on('click',function(){
    if ($('.menu').hasClass('open')) {
      $('.menu').removeClass('open');
    }else{
      $('.menu').addClass('open')
    }
  });
});

// $(document).ready(function(){
//   $('#close-it').on('click', function () {
//     $(this).removeClass('open');
//   })
// });

function myFunction() {
    document.getElementById("drop").classList.toggle("show-drop");
}

// Close the dropdown menu if the user clicks outside of it
window.onclick = function(event) {
  if (!event.target.matches('.drop-button')) {

    var dropdowns = document.getElementsByClassName("drop-menu");
    var i;
    for (i = 0; i < dropdowns.length; i++) {
      var openDropdown = dropdowns[i];
      if (openDropdown.classList.contains('show')) {
        openDropdown.classList.remove('show');
      }
    }
  }
}
function goBack() {
    window.history.back();
}
