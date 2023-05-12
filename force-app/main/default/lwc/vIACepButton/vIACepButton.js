import { LightningElement, api, wire } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import getCep from '@salesforce/apex/CepLookupController.getCep';

const fields = [
    'Account.CEP__c',
    'Account.CEP_Logradouro__c'
];

export default class CepLookup extends LightningElement {
    @api recordId; //Id da conta

    @wire(getRecord, { recordId: '$recordId', fields })
    account;

    handleClick() {
        const cep = this.account.data.fields.CEP__c.value;
        getCep({ cep: cep })
            .then(result => {
                const billingAddress = {
                    'CEP_Logradouro__c': result.logradouro
                };
                const recordInput = { fields: { 'CEP_Logradouro__c': billingAddress } };
                this.updateRecord(recordInput);
            })
            .catch(error => {
                console.error(error);
                this.showToast('Erro', 'Não foi possível atualizar o endereço', 'error');
            });
    }

    showToast(title, message, variant) {
        const event = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant
        });
        this.dispatchEvent(event);
    }
}
