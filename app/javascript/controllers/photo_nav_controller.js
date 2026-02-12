import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { prevUrl: String, nextUrl: String }

  navigate(url) {
    if (url) Turbo.visit(url)
  }

  // Keyboard: bound to window via data-action
  handleKey(event) {
    if (event.key === "ArrowLeft")  this.navigate(this.prevUrlValue)
    if (event.key === "ArrowRight") this.navigate(this.nextUrlValue)
  }

  // Touch swipe
  touchStart(event) {
    this._touchStartX = event.changedTouches[0].clientX
  }

  touchEnd(event) {
    const dx = event.changedTouches[0].clientX - this._touchStartX
    if (dx >  50) this.navigate(this.prevUrlValue)
    if (dx < -50) this.navigate(this.nextUrlValue)
  }
}
