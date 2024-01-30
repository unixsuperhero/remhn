import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="equip-grade-row"
export default class extends Controller {
  static targets = ['gradeList', 'stateIcon'];

  toggleRow() {
    this.element.classList.toggle('collapsed');

    this.stateIconTarget.classList.toggle('fa-caret-right');
    this.stateIconTarget.classList.toggle('fa-caret-down');
  }
}
