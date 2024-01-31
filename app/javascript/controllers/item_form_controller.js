import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="equip-grade-row"
export default class extends Controller {
  static targets = ['gradeList', 'collapsedIcon'];

  connect() {
    let raw_box = localStorage.getItem('itemBox') || '[]';
    let itembox = JSON.parse(raw_box);

    let inputs = this.element.getElementsByTagName('input');
    for(let i=0; i < inputs.length; ++i) {
      let item_id = inputs[i].dataset.item_id;
      if(itembox.length >= item_id) {
        inputs[i].value = itembox[item_id];
      }
    }
  }

  updateItem() {
    const input = event.target;
    let raw_box = localStorage.getItem('itemBox') || '[]';
    let itembox = JSON.parse(raw_box);
    itembox[input.dataset.item_id] = input.value
    localStorage.setItem('itemBox', JSON.stringify(itembox));
  }
}
