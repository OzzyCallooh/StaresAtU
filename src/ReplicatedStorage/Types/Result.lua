--!strict

type Ok<T> = {
	success: true;
	result: T;
	message: nil;
}

type Err = {
	success: false;
	message: string;
	result: nil;
}

export type Result<T> = Ok<T> | Err

return {}