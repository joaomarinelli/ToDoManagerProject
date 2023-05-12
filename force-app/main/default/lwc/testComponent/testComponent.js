import { LightningElement, track } from 'lwc';


export default class AccountCreator extends LightningElement {


    @track selectedRecordId;


    handleValueSelected(event) {
        this.selectedRecordId = event.detail;
    }
}