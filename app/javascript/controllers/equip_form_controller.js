import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="equip-grade-row"
export default class extends Controller {
  connect() {
    let raw_box = localStorage.getItem('equipBox') || '[]';
    let equipbox = JSON.parse(raw_box);

    let inputs = this.element.getElementsByTagName('input');
    for(let i=0; i < inputs.length; ++i) {
      let equip_id = inputs[i].dataset.equip_id;
      if(equipbox[equip_id]) {
        inputs[i].value = equipbox[equip_id];
      }
    }
  }

  updateItem() {
    const input = event.target;
    let raw_box = localStorage.getItem('equipBox') || '[]';
    let equipbox = JSON.parse(raw_box);
    equipbox[input.dataset.equip_id] = input.value
    localStorage.setItem('equipBox', JSON.stringify(equipbox));
  }
}
