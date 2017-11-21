export class ChecklistItem {
  constructor(element) {
    this.element = element
  }

  check() {
    this.element.removeClass('incomplete')
    this.element.addClass('complete')
    this.element.children('a').text(this.element.data('complete'))
  }

  uncheck() {
    this.element.removeClass('complete')
    this.element.addClass('incomplete')
    this.element.children('a').text(this.element.data('incomplete'))
  }
}
