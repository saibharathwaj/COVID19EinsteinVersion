import { LightningElement, api, track } from 'lwc';
import getStateWideDetails from '@salesforce/apex/CoronaStateWiseApex.getStateWideDetails';
import getStateWiseImpactsCOVID from '@salesforce/apex/CoronaStateWiseApex.getStateWiseImpactsCOVID';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import REVIEW_OBJECT from '@salesforce/schema/Review_Feedback__c';
import NAME_FIELD from '@salesforce/schema/Review_Feedback__c.Name';
import CITY_DISTRICT from '@salesforce/schema/Review_Feedback__c.City_District__c';
import COMMENT_FIELD from '@salesforce/schema/Review_Feedback__c.Comments__c';
import DESCRIPTION_FIELD from '@salesforce/schema/Review_Feedback__c.Description__c';
import EMAIL_FIELD from '@salesforce/schema/Review_Feedback__c.Email__c';
import PHONE_FIELD from '@salesforce/schema/Review_Feedback__c.Phone__c';
import STATE_FIELD from '@salesforce/schema/Review_Feedback__c.State__c';
const columns = [
    { label: 'State Name', fieldName: 'state' },
    { label: 'Confirmed', fieldName: 'confirmed' ,type:'number',cellAttributes: { class: 'slds-text-color_error slds-text-title_bold', alignment: 'left'}},
    { label: 'Active', fieldName: 'active', type:'number',cellAttributes: { class: 'slds-text-color_warning slds-text-title_bold', alignment: 'left'}},
    { label: 'Recovered', fieldName: 'recovered',type:'number',cellAttributes: { class: 'slds-text-color_success slds-text-title_bold',alignment: 'left'}},
    { label: 'Deaths', fieldName: 'deaths',type:'number',cellAttributes: { class: 'slds-text-color_error slds-text-title_bold',alignment: 'left'}},
];

const districtTableColumns = [
    { label: 'District Name', fieldName: 'districtName' },
    { label: 'Confirmed', fieldName: 'confirmed' ,type:'text',cellAttributes: { class: 'slds-text-color_error slds-text-title_bold', alignment: 'left'}},
    { label: 'Active', fieldName: 'active', type:'text',cellAttributes: { class: 'slds-text-color_warning slds-text-title_bold', alignment: 'left'}},
    { label: 'Recovered', fieldName: 'recovered',type:'text',cellAttributes: { class: 'slds-text-color_success slds-text-title_bold', alignment: 'left'}},
    { label: 'Deaths', fieldName: 'deceased',type:'text',cellAttributes: { class: 'slds-text-color_error slds-text-title_bold',alignment: 'left'}},
];

export default class CovidData extends LightningElement {
    @api nationalTotal;
    @api nationalData;
    @api stateData;
    error;
    @track columns=columns;
    @track districtTableColumns=districtTableColumns;
    @track states=[];
    @track value='Tamil Nadu';
    @track reviewObject=REVIEW_OBJECT;
    @track myField=[NAME_FIELD,CITY_DISTRICT,COMMENT_FIELD,DESCRIPTION_FIELD,EMAIL_FIELD,PHONE_FIELD,STATE_FIELD];

    connectedCallback(){
        getStateWideDetails()
        .then(result => {
            var data= result.filter(function(el){
                return el.state === 'Total';
            });
            if(data !=undefined){
                this.nationalTotal=data[0];
            }
            var stateData= result.filter(function(el) {
                return el.state !='Total';
            });
            if(stateData !=undefined){
                this.nationalData=stateData;
            }
            console.log('national data:::', this.nationalData);
            for(var key in this.nationalData){
                console.log('state Details:::', result[key].state);
                var sts={
                    label: result[key].state,
                    value: result[key].state
                };
                console.log('sts::::',sts);
                this.states.push(sts);
            }
           // this.handleChange(null);
            console.log('States::::', JSON.stringify(this.states));
        })
        .catch(error => {
            this.error=error;
            console.log('error:::::',JSON.stringify(error));
        })
    }
    handleChange(event){
        if(event == null){
            this.value='Tamil Nadu';
        } else {
            this.value=event.detail.value;
        }
        console.log('value:::', this.value);
        getStateWiseImpactsCOVID(
            {
                'stateName':this.value
            }
        )
        .then(result => {
            console.log('resp from result;::', result);
            this.stateData=result;
        })
        .catch(error => {
            this.error=error;
            console.log(JSON.stringify(this.error));
        })
    }

    handleSubmit(event){
        console.log('event submission:::'+event.detail.id);
        const evt= new ShowToastEvent({
            title: "Feedback Stored",
            message: "Record Created Successfully !!!",
            variant:"success"
        });
        this.dispatchEvent(evt);
    }
}