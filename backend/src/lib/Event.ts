export enum EventType {
	GENERAL_ADMISSION = 'GENERAL_ADMISSION',
	DAILY = 'DAILY',
}

export interface Event {
	id: string;
	name: string;
	startDate: number;
	endDate: number;
	location: string;
	image: string;
	type: EventType;
}