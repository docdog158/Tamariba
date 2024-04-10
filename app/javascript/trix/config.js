document.addEventListener("trix-initialize", function(event) {
  const buttonGroup = event.target.toolbarElement.querySelector('.trix-button-group');

  if (buttonGroup) {
    buttonGroup.classList.add('custom-button-group');
  }
});