$(() => { 
  $('body.controller-repositories.action-show code.clone-input-group input').click(function() {
    $(this).select()
  })
  $('body.controller-repositories.action-show code.clone-input-group button').click(function() {
    const $this = $(this)
    $this.siblings('input').click()
    document.execCommand("copy")
    const $flash = $this.parent().siblings('.flash.notice')
    $flash.show()
    setTimeout(function() {
      $flash.hide("fast")
    }, 1000)
  })
})
