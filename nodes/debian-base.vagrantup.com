{
  "name": "debian-base.vagrantup.com",
  "chef_environment": "_default",
  "run_list": [
    "role[vagrant]",
    "role[django_site]"
  ],
  "normal": {
    "tags": [

    ],
    "postgresql": {
      "password": {
        "postgres": "md527d6d6c830d0f17561fc7f520bfece55"
      }
    }
  }
}
