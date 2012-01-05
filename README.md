##Installation the required gems and the dependence

you need datamapper and sqlite3 to run this app.

##How to init and Run

	cd zzulib
	rake db_migrate
	rake set_email
	rake
when you execu the commend `rake set_email`,
you must set your email SMTP message to make it possible to send email through SMTP.
Or you can copy the `email.yaml.example` and rename it as `email.yaml`

	cp email.yaml.example email.yaml
and then change the email settings of yourself.
then you can view it in your broser: <http://localhost:3002/>