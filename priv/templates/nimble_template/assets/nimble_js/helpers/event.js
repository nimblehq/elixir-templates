export const dispatchEventFromElement = (
  element,
  eventName,
  eventDetail = {}
) => {
  const event = new CustomEvent(eventName, {
    detail: eventDetail,
    cancelable: true,
  });

  element.dispatchEvent(event);
};
