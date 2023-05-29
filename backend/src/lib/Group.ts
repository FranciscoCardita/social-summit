export enum NotificationType {
	ENTERED_VENUE = 'ENTERED_VENUE',
	LEFT_VENUE = 'LEFT_VENUE',
	COMING = 'COMING'
}

export interface Notification {
	id: string;
	type: NotificationType;
	date: number;
	description: string;
}

export interface BasicUser {
	id: string;
	name: string;
}

export interface Group {
	users: BasicUser[];
	notifications: Notification[];
}