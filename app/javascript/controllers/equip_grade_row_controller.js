import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="equip-grade-row"
export default class extends Controller {
  static targets = ['gradeList', 'collapsedIcon'];

  toggleRow() {
    this.element.classList.toggle('collapsed');

    this.collapsedIconTarget.classList.toggle('fa-caret-right');
    this.collapsedIconTarget.classList.toggle('fa-caret-down');
  }
}
