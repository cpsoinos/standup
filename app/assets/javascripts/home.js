$(document).ready(function() {

  $.material.init();
  $.material.ripples()

  function slickifyDropdown(selector) {
    selector.ddslick({
      data: JSON.parse(gon.contacts),
      imagePosition: "left",
      width: 300,
      selectText: "Whose update is this?",
      onSelected: function(e) {
        hidden_field = $(e.selectedItem).parents(".dd-container").next();
        hidden_field.val(e.selectedData.value);
      }
    });
  }

  slickifyDropdown($(".contacts-dropdown"));

  var personalCount = 0
  var professionalCount = 0

  $("#add-personal").click(function(ev) {
    var fields = $("#personal-form-fields").clone()

    fields.removeAttr("id")
    clear_form_elements(fields);

    fields.appendTo($(".personal-form"));
    fields.find($(".dd-container")).empty();
    slickifyDropdown(fields.find($(".dd-container")))
  })

  $("#add-professional").click(function(ev) {
    var fields = $("#professional-form-fields").clone()

    fields.removeAttr("id")
    clear_form_elements(fields);

    fields.appendTo($(".professional-form"));
    fields.find($(".dd-container")).empty();
    slickifyDropdown(fields.find($(".dd-container")))
  })

  function clear_form_elements(fields) {
    fields.find(':input').each(function() {
      switch(this.type) {
          case 'password':
          case 'text':
          case 'textarea':
          case 'file':
          case 'select-one':
          case 'select-multiple':
            jQuery(this).val('');
            break;
          case 'checkbox':
          case 'radio':
            this.checked = false;
      }
    });
  }

});
