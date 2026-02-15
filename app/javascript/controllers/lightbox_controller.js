import { Controller } from "@hotwired/stimulus"

const STORAGE_KEY = "treecal_lightbox_open"

export default class extends Controller {
  static targets = ["overlay"]
  static values = { prevUrl: String, nextUrl: String }

  connect() {
    if (sessionStorage.getItem(STORAGE_KEY) === "true") this.open()
  }

  open() {
    sessionStorage.setItem(STORAGE_KEY, "true")
    this.overlayTarget.classList.remove("hidden")
    document.body.classList.add("overflow-hidden")
  }

  close() {
    sessionStorage.removeItem(STORAGE_KEY)
    this.overlayTarget.classList.add("hidden")
    document.body.classList.remove("overflow-hidden")
  }

  get isOpen() { return !this.overlayTarget.classList.contains("hidden") }

  navigate(url) { if (url) Turbo.visit(url) }
  navigatePrev() { this.navigate(this.prevUrlValue) }
  navigateNext() { this.navigate(this.nextUrlValue) }

  handleKey(event) {
    if (event.key === "ArrowLeft")          this.navigate(this.prevUrlValue)
    if (event.key === "ArrowRight")         this.navigate(this.nextUrlValue)
    if (event.key === "Escape" && this.isOpen) this.close()
  }

  touchStart(event) {
    this._startX = event.changedTouches[0].clientX
    this._startY = event.changedTouches[0].clientY
  }

  touchEnd(event) {
    const dx = event.changedTouches[0].clientX - this._startX
    const dy = event.changedTouches[0].clientY - this._startY
    if (Math.abs(dy) > Math.abs(dx)) {
      if (dy > 50 && this.isOpen) this.close()   // swipe down → close
    } else {
      if (dx >  50) this.navigate(this.prevUrlValue) // swipe right → prev
      if (dx < -50) this.navigate(this.nextUrlValue) // swipe left  → next
    }
  }
}
