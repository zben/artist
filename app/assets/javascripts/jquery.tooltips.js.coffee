$ ->
  $('.formtastic p.inline-hints').each (index) -> 
      $(this).hide()
      label = $(this).siblings('label')
      label.append(
          "<a href='#' title='" + 
             $(this).html() + 
             "' class='hint_modal'>
              (?) 
             </a>"
        )
