function validateForm(formId) {
    let form = document.getElementById(formId);
    let inputs = form.querySelectorAll("input, select");
    let valid = true;

    inputs.forEach(input => {
        let tip = input.nextElementSibling;

        if (input.value.trim() === "") {
            input.classList.add("error");
            if (tip && tip.classList.contains("tooltip")) {
                tip.style.display = "block";
            }
            valid = false;
        } else {
            input.classList.remove("error");
            if (tip && tip.classList.contains("tooltip")) {
                tip.style.display = "none";
            }
        }
    });

    if (!valid) {
        alert("⚠️ All fields are required");
    }

    return valid;
}

function validateDoctorRegister() {
    let valid = true;

    function check(id, tipId) {
        let el = document.getElementById(id);
        let tip = document.getElementById(tipId);

        if (el.value.trim() === "") {
            el.classList.add("error");
            tip.style.display = "block";
            valid = false;
        } else {
            el.classList.remove("error");
            tip.style.display = "none";
        }
    }

    check("name", "nameTip");
    check("speciality", "specTip");
    check("email", "emailTip");
    check("password", "passTip");

    let disease = document.getElementById("disease");
    let diseaseTip = document.getElementById("diseaseTip");

    if (disease.value === "") {
        disease.classList.add("error");
        diseaseTip.style.display = "block";
        valid = false;
    } else {
        disease.classList.remove("error");
        diseaseTip.style.display = "none";
    }

    if (!valid) {
        alert("⚠️ Please fill all required fields");
    }

    return valid;
}

function unlockVideo(dateTime, btnId) {
           const now = new Date().getTime();
           const appt = new Date(dateTime).getTime();

           if (now >= appt) {
               const btn = document.getElementById(btnId);
               btn.disabled = false;
               btn.innerText = "Join Video Call";
               btn.classList.add("active-video");
           }
       }
	  
	   
function handleVideoButton(dateTime, btnId, statusId) {
	       const now = new Date().getTime();
	       const apptTime = new Date(dateTime).getTime();
	       const oneDay = 24 * 60 * 60 * 1000;

	       const btn = document.getElementById(btnId);
	       const status = document.getElementById(statusId);

	       if (now >= apptTime) {
	           btn.disabled = false;
	           btn.innerText = "Start Video Call";
	       }

	       if (now > apptTime + oneDay) {
	           status.innerText = "Completed";
	           status.classList.remove("scheduled");
	           status.classList.add("completed");
	           btn.style.display = "none";
	       }
	   }
document.addEventListener("DOMContentLoaded", () => {

	       const cards = document.querySelectorAll(".appointment-card");

	       cards.forEach(card => {

	           const dateTimeStr = card.dataset.datetime;
	           if (!dateTimeStr) return;

	           const statusEl = card.querySelector(".status");
	           const timerEl = card.querySelector(".timer");
	           const videoBtn = card.querySelector(".video-btn");
			   const reviewBtn = card.querySelector(".review-btn")

	           const startTime = new Date(dateTimeStr).getTime();
	           const endTime = startTime + (60 * 60 * 1000); // +1 hour

	           function updateCard() {
	               const now = Date.now();

	               /* ================= BEFORE START ================= */
	               if (now < startTime) {
	                   const diff = startTime - now;

	                   timerEl.textContent = "Starts in " + format(diff);

	                   statusEl.textContent = "Scheduled";
	                   statusEl.className = "status scheduled";

	                   videoBtn.disabled = true;
	                   videoBtn.textContent = "Video Call Locked";
	                   videoBtn.classList.remove("active");
	                   videoBtn.style.display = "block";
	                   videoBtn.onclick = null;
					   
	               }

	               /* ================= LIVE (1 HOUR) ================= */
	               else if (now >= startTime && now <= endTime) {
	                   const diff = endTime - now;

	                   timerEl.textContent = "Ends in " + format(diff);

	                   statusEl.textContent = "Live";
	                   statusEl.className = "status live";

	                   videoBtn.disabled = false;
	                   videoBtn.textContent = "Join Video Call";
	                   videoBtn.classList.add("active");
	                   videoBtn.style.display = "block";

	                  
					   videoBtn.onclick = function () {
					          window.location.href = "telemedicine.jsp";
					      };
	               }

	               /* ================= COMPLETED ================= */
	               else {
	                   timerEl.textContent = "--";

	                   statusEl.textContent = "Completed";
	                   statusEl.className = "status completed";

	                   videoBtn.style.display = "none";
	                   videoBtn.onclick = null;
					   
					   const reviewBtn = card.querySelector(".review-btn");
					       if (reviewBtn) {
					           reviewBtn.style.display = "block";
					       }
	               }
	           }
			                   const oneHour = 60 * 60 * 1000;
			   		           const twentyFourHours = 24 * 60 * 60 * 1000;

			   		           const appointmentEnd = startTime + oneHour;
			   		           const hideAfter = appointmentEnd + twentyFourHours;

			   		           const now = new Date().getTime();

			   		           // 🔥 REMOVE CARD COMPLETELY AFTER 24 HOURS
			   		           if (now > hideAfter) {
			   		               card.remove();
			   		               return;
			   		           }

	           updateCard();
	           setInterval(updateCard, 1000);
	       });
	   });

	   /* ================= TIME FORMAT ================= */
	   function format(ms) {
	       let totalSeconds = Math.floor(ms / 1000);
	       let hrs = Math.floor(totalSeconds / 3600);
	       let mins = Math.floor((totalSeconds % 3600) / 60);
	       let secs = totalSeconds % 60;

	       return (
	           String(hrs).padStart(2, "0") + ":" +
	           String(mins).padStart(2, "0") + ":" +
	           String(secs).padStart(2, "0")
	       );
	   }
	   const link = document.getElementById("videoLink");
	       if (link.getAttribute("href") && link.getAttribute("href") !== "") {
	           link.style.pointerEvents = "auto";
	           link.style.opacity = "1";
	       }
		   

		   
		   function handleDoctorCard(card) {
		       const start = new Date(card.dataset.datetime).getTime();
		       const end = start + (60 * 60 * 1000); // +1 hour
		       const now = Date.now();

		       const reviewBtn = card.querySelector(".review-btn");

		       if (now > end) {
		           reviewBtn.style.display = "block";
		       }
		   }

		