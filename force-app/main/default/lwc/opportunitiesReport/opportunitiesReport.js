import { LightningElement, wire, track } from 'lwc';
import getStagesOptions from '@salesforce/apex/OpportunitReportController.getStageOptions';
import getOpps from '@salesforce/apex/OpportunitReportController.getOpportunities';

export default class OpportunitiesReport extends LightningElement {
    @track closeDate;
    @track stage;
    @track stageOptions;
    @track opportunities;
    @track selectedAccount;
    selectedAcc;

    handleValueSelected(event) {
        this.selectedAccount = event.detail[0];
        console.log('SELECT ACCOUNT', this.selectedAccount);
    }

    @wire(getStagesOptions)
    wiredStageOptions({error, data}){
        if(data){
            this.stageOptions = data.map(options => {
                return {label: options.label, value: options.value};
            });
        }else if(error){
            console.error(error);
        }
    }

    handleCloseDateChange(event){
        this.closeDate = new Date(event.target.value);
    }

    handleStageChange(event){
        this.stage = event.target.value;
    }

    handleGenerateReport(){
        getOpps({closeDate: this.closeDate, selectedAccount: this.selectedAccount, stage: this.stage})
        .then(result => {
            this.opportunities = result;
        })
        .catch(error => {
            console.error(error);
        });
    }
}
