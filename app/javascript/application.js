// app/javascript/application.js
//= require jquery
//= require jquery_ujs
import { Turbo } from "@hotwired/turbo-rails"
import "./controllers"
import "bootstrap"
console.log("channels being imported")
import "./channels" // Ensure this line is present to load all channels
