import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["container", "slide", "dot"]

  connect() {
    this.currentIndex = 0
    this.totalSlides = this.slideTargets.length
    this.showSlide(this.currentIndex)
  }

  next() {
    this.currentIndex = (this.currentIndex + 1) % this.totalSlides
    this.showSlide(this.currentIndex)
  }

  prev() {
    this.currentIndex = (this.currentIndex - 1 + this.totalSlides) % this.totalSlides
    this.showSlide(this.currentIndex)
  }

  goToSlide(event) {
    const index = parseInt(event.currentTarget.dataset.index)
    this.currentIndex = index
    this.showSlide(this.currentIndex)
  }

  showSlide(index) {
    // Hide all slides
    this.slideTargets.forEach((slide, i) => {
      slide.classList.toggle('opacity-0', i !== index)
      slide.classList.toggle('opacity-100', i === index)
    })

    // Update dots
    this.dotTargets.forEach((dot, i) => {
      dot.classList.toggle('w-4', i === index)
      dot.classList.toggle('w-2', i !== index)
      dot.classList.toggle('bg-opacity-100', i === index)
      dot.classList.toggle('bg-opacity-50', i !== index)
    })
  }
} 