// utils/dateUtils.js
const formatDateToJakarta = (date) => {
  const jakartaDateTime = new Date(date).toLocaleString("id-ID", {
    timeZone: "Asia/Jakarta",
  });
  const [datePart, timePart] = jakartaDateTime.split(",");
  const [day, month, year] = datePart.split("/");
  const formattedDate = `${year}-${month.padStart(2, "0")}-${day.padStart(
    2,
    "0"
  )}`;
  return `${formattedDate} ${timePart}`;
};

function getFormattedDateToDatabase() {
  const date = new Date();
  return (
    date.getFullYear() +
    "-" +
    String(date.getMonth() + 1).padStart(2, "0") +
    "-" +
    String(date.getDate()).padStart(2, "0") +
    " " +
    String(date.getHours()).padStart(2, "0") +
    ":" +
    String(date.getMinutes()).padStart(2, "0") +
    ":" +
    String(date.getSeconds()).padStart(2, "0")
  );
}

module.exports = { formatDateToJakarta, getFormattedDateToDatabase };
