import { User } from './User';

export enum NotificationType {
	ENTERED_VENUE = 'ENTERED_VENUE',
	LEFT_VENUE = 'LEFT_VENUE',
	COMING = 'COMING'
}

export interface Notification {
	id: string;
	type: NotificationType;
	date: Date;
	description: string;
}

export interface Group {
	users: User[];
	notifications: Notification[];
}