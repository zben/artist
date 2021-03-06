// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery
//= require jquery_ujs
//= require_tree .
//= require tinymce-jquery
//= require best_in_place
//= require best_in_place.purr
//= require jquery.remotipart

$(document).ready(function() {
  $('#skill_picker').click(function(event){ 
    if($(this).text() == '查看所有技能'){
      $('.skill_list').show();
      $(this).text('不使用选择列表');
      $('.skill_list input').attr("disabled", false);
    }
    else{
      $('.skill_list').hide();
      $(this).text('查看所有技能');
      $('.skill_list input').attr("disabled", true);
    }
  event.preventDefault();
  });


  $('.tiny textarea').tinymce({
    content_css: "/style.css",
    theme : "advanced",
    oninit : "setPlainText",
    plugins : "paste",
    paste_text_sticky : true,
    setup : function(ed) {
      ed.onInit.add(function(ed) {
        ed.pasteAsPlainText = true;
      });
    },
    theme_advanced_buttons1 : "bold,bullist,numlist",
    theme_advanced_buttons2: "",
    theme_advanced_buttons3: "",
    theme_advanced_buttons4: "",
    theme_advanced_toolbar_location : "top",
    theme_advanced_toolbar_align : "left",

  });


  $(".alert-message").alert()

    $('#slides').slides({
      preload: true,
      preloadImage: 'img/loading.gif',
      play: 5000,
      pause: 2500,
      hoverPause: true
    });

  // $('a.bookmark').bind('click',function(){
  //   $(this).text('Updating');
  // });

  $('#modal-from-dom').modal({
    backdrop: "static"
  });

  jQuery(".best_in_place").best_in_place();

  var $container = $('#image_blocks');
  $container.imagesLoaded(function(){
    $container.masonry({
      itemSelector : '.image_block',
      columnWidth : 310,
      isFitWidth: true,
    });
  });

  var $container2 = $('#image_blocks.small');
  $container2.imagesLoaded(function(){
    $container2.masonry({
      itemSelector : '.image_block',
      columnWidth : 130,
      isFitWidth: true,
    });
  });


   $container.infinitescroll({
        debug: true,
        navSelector  : '.pagination',    // selector for the paged navigation 
        nextSelector : 'li.next_page a',  // selector for the NEXT link (to page 2)
        itemSelector : '.image_block',     // selector for all items you'll retrieve
        loading: {
            finishedMsg: 'End of page',
            msgText: 'Loading more artwork for you...',
            img: "/assets/spinner.gif"
          }
        },
        // trigger Masonry as a callback
        function( newElements ) {
          // hide new items while they are loading
          var $newElems = $( newElements ).css({ opacity: 0 });
          // ensure that images load before adding to masonry layout
          $newElems.imagesLoaded(function(){
            // show elems now they're ready
            $newElems.animate({ opacity: 1 });
            $container.masonry( 'appended', $newElems, true ); 
          });
        }
      );
// formtastic.qtip2.min.js Copyright (C) 2012 Gyorgy Schreiber (gydotschreiberatmobilitydothu)  - MIT & GPL licenses apply
$(".inline-hints").hide();
$(".inline-hints").each(function () {
    var input = $(this.parentNode);
    var q = "<span class='q'> (?) </span>"
    input.find('label').append(q);
    input.find('label').qtip({
        position: {
            my: "bottom left",
            at: "top right",
            target: input.find('span.q')
        },
        content: {
            text: function (api) {
                var hinttext = $(input)[0].lastChild.firstChild.parentElement.attributes[0].nodeName == 'class' && $(input)[0].lastChild.firstChild.parentElement.attributes[0].nodeValue == 'inline-errors' ? $(input)[0].children[$(this)[0].children.length - 2].firstChild.wholeText : $(input)[0].lastChild.firstChild.wholeText;
                return hinttext;
            }
        },
        style: {
                  classes: 'ui-tooltip-shadow ui-tooltip-rounded ui-tooltip-youtube'
                }
    });
});
 
});
