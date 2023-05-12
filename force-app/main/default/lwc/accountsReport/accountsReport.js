import { LightningElement, wire } from 'lwc';
import getAccounts from '@salesforce/apex/AccountReportController.getAccounts';
import { getRecord } from 'lightning/uiRecordApi';
import getCustomerPriorityOptions from '@salesforce/apex/AccountReportController.getCustomerPriority';


export default class AccountReport extends LightningElement {
    startDate;
    endDate;
    customerPriority;
    accounts;
    customerPriorityOptions = '';
    

    @wire(getCustomerPriorityOptions)
    wiredCustomerPriorityOptions({error, data}){
        if(data){
            this.customerPriorityOptions = data.map(options => {
                return {label: options.label, value: options.value};
            });
        }else if (error){
            console.error(error);
        }
    }

    handleStartDateChange(event) {
        this.startDate = new Date(event.target.value);
    }

    handleEndDateChange(event) {
        this.endDate = new Date(event.target.value);
    }

    handleCustomerPriorityChange(event) {
        this.customerPriority = event.target.value;
    }


    handleGenerateReport() {
        getAccounts({ startDate: this.startDate, endDate: this.endDate, customerPriority: this.customerPriority })
            .then(result => {
                this.accounts = result;
            })
            .catch(error => {
                console.error(error);
            });
    }
}
