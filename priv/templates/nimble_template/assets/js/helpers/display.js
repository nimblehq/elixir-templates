/*
 * Helper functions to show and hide elements
 * */
export function showElement(elementRef) {
  elementRef.classList.remove("d--none");
}

export function hideElement(elementRef) {
  elementRef.classList.add("d--none");
}
