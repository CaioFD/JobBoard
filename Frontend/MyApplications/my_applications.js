if (!getToken()) location.href = '../login/login.html';

const applicationsList = document.getElementById('applications_list');
const applicationsMessage = document.getElementById('applications_message');

function showEmpty() {
    applicationsMessage.textContent = 'You have not applied for any job yet. ';
    const link = document.createElement('a');
    link.href = '../Jobs/jobs.html';
    link.textContent = 'See all jobs';
    applicationsMessage.appendChild(link);
}

async function cancelApplication(application, row) {
    if (!confirm(`Cancel your application for "${application.title}"?`)) return;
    try {
        const response = await apiFetch(`/api/jobs/${encodeURIComponent(application.id_job)}/apply`, { method: 'DELETE' });
        // 404 means it was already cancelled, so the row should go away as well
        if (response.ok || response.status === 404) {
            row.remove();
            if (applicationsList.rows.length === 0) showEmpty();
        } else {
            applicationsMessage.textContent = (await response.json()).detail;
        }
    } catch (error) {
        applicationsMessage.textContent = 'Could not reach the server. Is the backend running?';
    }
}

function showApplication(application) {
    const row = applicationsList.insertRow();

    const job = document.createElement('a');
    job.href = `../JobDetails/job_details.html?id=${encodeURIComponent(application.id_job)}`;
    job.textContent = application.title;
    row.insertCell().appendChild(job);

    row.insertCell().textContent = application.company;
    row.insertCell().textContent = `${application.city}, ${application.country}`;
    row.insertCell().textContent = new Date(application.applied_at).toLocaleString();

    const cancelBtn = document.createElement('button');
    cancelBtn.type = 'button';
    cancelBtn.className = 'btn btn_cancel';
    cancelBtn.textContent = 'Cancel';
    cancelBtn.setAttribute('aria-label', `Cancel application for ${application.title}`);
    cancelBtn.addEventListener('click', () => cancelApplication(application, row));
    row.insertCell().appendChild(cancelBtn);
}

async function loadApplications() {
    try {
        const response = await apiFetch('/api/my_applications');
        const data = await response.json();
        if (!response.ok) {
            applicationsMessage.textContent = data.detail;
            return;
        }
        if (data.applications.length === 0) {
            showEmpty();
            return;
        }
        data.applications.forEach(showApplication);
    } catch (error) {
        applicationsMessage.textContent = 'Could not reach the server. Is the backend running?';
    }
}

loadApplications();
