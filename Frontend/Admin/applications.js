// Only hides the page from non-admins; the real check is require_admin on the backend routes
if (getUser()?.role !== 'admin') location.href = '../login/login.html';

const applicationsList = document.getElementById('applications_list');
const applicationsMessage = document.getElementById('applications_message');

async function openCv(idUser) {
    // open the tab before the await, otherwise the browser blocks it as a popup
    const tab = window.open('', '_blank');
    const response = await apiFetch(`/api/users/${encodeURIComponent(idUser)}/cv`);
    if (!response.ok) {
        tab.close();
        applicationsMessage.textContent = 'Could not load this CV';
        return;
    }
    tab.location = URL.createObjectURL(await response.blob());
}

function showApplication(application) {
    const row = applicationsList.insertRow();
    row.insertCell().textContent = application.full_name;
    row.insertCell().textContent = application.email;
    row.insertCell().textContent = application.age;

    const job = document.createElement('a');
    job.href = `../JobDetails/job_details.html?id=${encodeURIComponent(application.id_job)}`;
    job.textContent = `${application.title} (${application.company})`;
    row.insertCell().appendChild(job);

    row.insertCell().textContent = new Date(application.applied_at).toLocaleString();

    const cvBtn = document.createElement('button');
    cvBtn.type = 'button';
    cvBtn.className = 'btn';
    cvBtn.textContent = 'View CV';
    cvBtn.setAttribute('aria-label', `View CV of ${application.full_name}`);
    cvBtn.addEventListener('click', () => openCv(application.id_user));
    row.insertCell().appendChild(cvBtn);
}

async function loadApplications() {
    try {
        const response = await apiFetch('/api/applications');
        const data = await response.json();
        if (!response.ok) {
            applicationsMessage.textContent = data.detail;
            return;
        }
        if (data.applications.length === 0) {
            applicationsMessage.textContent = 'No applications yet.';
            return;
        }
        data.applications.forEach(showApplication);
    } catch (error) {
        applicationsMessage.textContent = 'Could not reach the server. Is the backend running?';
    }
}

loadApplications();
