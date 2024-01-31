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
      itembox[item_id] = itembox[item_id] || ['', ''];
      if(inputs[i].dataset.data_type == 'count') {
        if(typeof itembox[item_id][0] !== "undefined") {
          inputs[i].value = itembox[item_id][0];
        }
      }
      if(inputs[i].dataset.data_type == 'position') {
        if(typeof itembox[item_id][1] !== "undefined") {
          inputs[i].value = itembox[item_id][1];
        }
      }
    }
  }

  updateItem() {
    const input = event.target;
    let raw_box = localStorage.getItem('itemBox') || '[]';
    let itembox = JSON.parse(raw_box);
    let result = itembox[input.dataset.item_id] || [];
    if(input.dataset.data_type == 'count') {
      result[0] = input.value;
    }
    if(input.dataset.data_type == 'position') {
      result[1] = input.value;
    }
    itembox[input.dataset.item_id] = result;
    localStorage.setItem('itemBox', JSON.stringify(itembox));
  }
}
