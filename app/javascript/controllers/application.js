import { Application } from "@hotwired/stimulus"
import Rails from "@rails/ujs"
Rails.start()

// Other imports...

const application = Application.start()

// Configure Stimulus development experience
application.debug = false
window.Stimulus   = application

export { application }
