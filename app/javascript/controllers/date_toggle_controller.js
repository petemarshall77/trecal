import { Controller } from "@hotwired/stimulus"

const STORAGE_KEY = "treecal_show_dates"

export default class extends Controller {
  static targets = ["label", "checkbox", "grid", "frame", "caption"]

  connect() {
    this.checkboxTarget.checked = this.stored() !== "false"
    this.apply()
  }

  toggle() {
    try { localStorage.setItem(STORAGE_KEY, this.checkboxTarget.checked) } catch (e) {}
    this.apply()
  }

  apply() {
    const show = this.checkboxTarget.checked
    this.labelTargets.forEach((label) => label.classList.toggle("hidden", !show))

    // Without dates, show a seamless grid: no gaps, borders or rounded corners
    this.gridTargets.forEach((grid) => {
      grid.classList.toggle("gap-2", show)
      grid.classList.toggle("gap-0", !show)
    })
    // Captions stay `hidden` but become visible on hover (hover-capable devices only)
    this.captionTargets.forEach((caption) => caption.classList.toggle("group-hover:block", !show))
    this.frameTargets.forEach((frame) => {
      frame.classList.toggle("rounded", show)
      frame.classList.toggle("border", show)
      frame.classList.toggle("border-gray-200", show)
    })
  }

  stored() {
    try { return localStorage.getItem(STORAGE_KEY) } catch (e) { return null }
  }
}
