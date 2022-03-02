"use strict";

export const isMobileScreenSize = () => {
  return window.matchMedia("(max-width: 767px)").matches;
};
