// Only hides the page from non-admins; the real check is require_admin on the backend routes
if (getUser()?.role !== 'admin') location.href = '../login/login.html';

const jobForm = document.getElementById('job_form');
const formMessage = document.getElementById('form_message');
// create_job.html?id=JOB123 edits that job instead of creating a new one
const editId = new URLSearchParams(location.search).get('id');
const yearsField = document.getElementById('years_field');
const yearsSelect = document.getElementById('experience_years');

document.querySelectorAll('input[name="experience"]').forEach(radio => {
    radio.addEventListener('change', () => {
        const needsExperience = radio.value === 'required';
        yearsField.hidden = !needsExperience;
        yearsSelect.required = needsExperience;
        if (!needsExperience) yearsSelect.value = '';
    });
});

// Categories and cities come from the database, so the job is saved with their real ids
async function loadOptions() {
    try {
        const categories = await (await fetch(API_URL + '/api/categories_HomePage')).json();
        for (const category of categories.categories) {
            jobForm.category.add(new Option(category.name, category.id));
        }
        const cities = await (await fetch(API_URL + '/api/cities')).json();
        const groups = {};
        for (const city of cities.cities) {
            if (!groups[city.country]) {
                groups[city.country] = document.createElement('optgroup');
                groups[city.country].label = city.country;
                jobForm.city.appendChild(groups[city.country]);
            }
            groups[city.country].appendChild(new Option(city.city, city.id));
        }
    } catch (error) {
        formMessage.textContent = 'Could not reach the server. Is the backend running?';
    }
}

// Old jobs were saved as "Full time" while the form uses "Full Time", so match ignoring case
function selectOption(select, value, addIfMissing = false) {
    const option = [...select.options].find(o => o.value.toLowerCase() === String(value).toLowerCase());
    if (option) option.selected = true;
    else if (addIfMissing) select.add(new Option(value, value, true, true));
}

async function loadJob() {
    document.title = 'JobBoard - Edit Job';
    document.querySelector('#hero h1').textContent = 'Edit Job';
    jobForm.querySelector('button[type="submit"]').textContent = 'Save changes';
    try {
        const response = await fetch(API_URL + '/api/jobs/' + encodeURIComponent(editId));
        const job = await response.json();
        if (!response.ok) {
            formMessage.textContent = job.detail;
            return;
        }
        jobForm.title.value = job.title;
        jobForm.company.value = job.company;
        selectOption(jobForm.job_type, job.job_type);
        selectOption(jobForm.category, job.id_category);
        selectOption(jobForm.degree, job.degree, true);
        selectOption(jobForm.currency, job.currency);
        selectOption(jobForm.city, job.id_city);
        if (job.experience > 0) {
            const required = jobForm.querySelector('input[name="experience"][value="required"]');
            required.checked = true;
            required.dispatchEvent(new Event('change'));
            yearsSelect.value = String(job.experience);
        }
        jobForm.salary_min.value = job.min_salary;
        jobForm.salary_max.value = job.max_salary;
        jobForm.description.value = job.description;
        jobForm.skills.value = job.skills;
    } catch (error) {
        formMessage.textContent = 'Could not reach the server. Is the backend running?';
    }
}

jobForm.addEventListener('submit', async (event) => {
    event.preventDefault();
    formMessage.textContent = '';
    if (Number(jobForm.salary_min.value) >= Number(jobForm.salary_max.value)) {
        formMessage.textContent = 'Minimum salary must be lower than the maximum salary';
        return;
    }
    try {
        const response = await apiFetch(editId ? '/api/jobs/' + encodeURIComponent(editId) : '/api/jobs', {
            method: editId ? 'PUT' : 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({
                title: jobForm.title.value,
                company: jobForm.company.value,
                job_type: jobForm.job_type.value,
                id_category: jobForm.category.value,
                degree: jobForm.degree.value,
                experience: Number(jobForm.experience_years.value || 0),
                currency: jobForm.currency.value,
                min_salary: Number(jobForm.salary_min.value),
                max_salary: Number(jobForm.salary_max.value),
                id_city: jobForm.city.value,
                description: jobForm.description.value,
                skills: jobForm.skills.value
            })
        });
        const data = await response.json();
        if (!response.ok) {
            formMessage.textContent = typeof data.detail === 'string' ? data.detail : 'Please check the fields and try again.';
            return;
        }
        location.href = '../Jobs/jobs.html';
    } catch (error) {
        formMessage.textContent = 'Could not reach the server. Is the backend running?';
    }
});

// the job can only be filled in after the category and city lists exist
loadOptions().then(() => { if (editId) loadJob(); });
