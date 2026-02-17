import { LightningElement, api, wire } from 'lwc';
import { getRecord, getFieldValue, notifyRecordUpdateAvailable, GetRecordWireAdapter } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import CLAN_TAG_FIELD from '@salesforce/schema/Clan__c.Tag__c';
import registerForTracking from '@salesforce/apex/ClansController.registerForTracking';

interface ApexResponse {
    message: string;
}

type ToastVariant = 'success' | 'info' | 'warning' | 'error';

export default class RegisterClanTracking extends LightningElement {
    @api recordId!: string;

    @wire(getRecord, { recordId: '$recordId', fields: [CLAN_TAG_FIELD] })
    clanRecord!: GetRecordWireAdapter;

    @api invoke(): void {
        if (this.recordId && this.clanRecord.data) {
            const clanTag = getFieldValue(this.clanRecord.data, CLAN_TAG_FIELD) as string;

            registerForTracking({ clanTag })
                .then((data: ApexResponse) => {
                    const variant: ToastVariant = data.message.includes('successful')
                        ? 'success'
                        : data.message.includes('pending')
                        ? 'info'
                        : 'error';
                    this.showToast(variant, this.capitalizeVariant(variant), data.message);
                })
                .catch((error: Error) => {
                    this.showToast('error', 'Unhandled Exception', error.message);
                });
        }
    }

    private showToast(variant: ToastVariant, title: string, message: string): void {
        this.dispatchEvent(
            new ShowToastEvent({
                variant,
                title,
                message
            })
        );

        notifyRecordUpdateAvailable([{ recordId: this.recordId }]);
    }

    private capitalizeVariant(variant: ToastVariant): string {
        return variant.charAt(0).toUpperCase() + variant.slice(1);
    }
}
