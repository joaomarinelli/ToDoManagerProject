import { LightningElement, api, wire } from 'lwc';
import { getRecord, updateRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getEndereco from '@salesforce/apex/AtualizarEnderecoAccountController.getEndereco';

const FIELDS = ['Account.CEP__c', 'Account.BillingStreet', 'Account.BillingCity', 'Account.BillingState', 'Account.BillingCountry'];

export default class AtualizarEnderecoButton extends LightningElement {
    @api recordId;

    @wire(getRecord, { recordId: '$recordId', fields: FIELDS })
    account;

    handleUpdateAddress() {
        let cep = this.account.data.fields.CEP__c.value;
        if (cep) {
            getEndereco({ cep: cep })
                .then(result => {
                    let endereco = JSON.parse(result);
                    console.log(endereco);
                    if (endereco.erro) {
                        this.showToast('Erro', 'Não foi possível encontrar o endereço', 'error');
                    } else {
                        console.log('Passei aqui');
                        const fields = {};
                        fields ['Id'] = this.recordId;
                        fields['BillingStreet'] = endereco.logradouro;
                        fields['BillingCity'] = endereco.localidade;
                        fields['BillingState'] = endereco.uf;
                        /* fields['CEP_Logradouro__c'] = logradouro;
                        fields['CEP_localidade__c'] = cidade;
                        fields['CEP_bairro__c'] = bairro;
                        fields['CEP_uf__c'] = uf; */
                        updateRecord({ fields })
                            .then(() => {
                            console.log('Record updated');
                            this.showToast('Sucesso', 'Endereço atualizado com sucesso', 'success');
                        })
                            .catch(error => {
                            console.error(error);
                            this.showToast('Erro', 'Não foi possível atualizar o endereço', 'error');
                        });
                        console.log(result);

                    }
                })
                .catch(error => {
                    console.error(error);
                    this.showToast('Erro', 'Não foi possível obter o endereço', 'error');
                });
        } else {
            this.showToast('Atenção', 'O campo CEP está vazio', 'warning');
        }
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
