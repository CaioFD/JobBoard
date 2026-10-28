// One page for every job: job_details.html?id=JOB001 loads that job from the backend
const jobId = new URLSearchParams(location.search).get('id');
const CURRENCY_SYMBOLS = { USD: '$', EUR: '€', GBP: '£', BRL: 'R$', MAD: 'DH ' };

// Text typed in a textarea becomes one item per non-empty line
function lines(text) {
    return text.split('\n').map(line => line.trim()).filter(line => line !== '');
}

function experienceText(years) {
    if (years === 0) return 'No experience needed';
    if (years >= 5) return '5+ Years';
    return years === 1 ? '1 Year' : `${years} Years`;
}

function showNotFound(message) {
    document.getElementById('job_title').textContent = 'Job not found';
    const main = document.getElementById('job_details_page');
    main.innerHTML = '';
    const p = document.createElement('p');
    p.className = 'not_found';
    p.append(message + ' ');
    const link = document.createElement('a');
    link.href = '../Jobs/jobs.html';
    link.textContent = 'See all jobs';
    p.appendChild(link);
    main.appendChild(p);
}

function showJob(job) {
    document.title = `JobBoard - ${job.title}`;
    document.getElementById('job_title').textContent = job.title;
    document.getElementById('job_company').textContent = job.company;

    const description = document.getElementById('job_description');
    for (const paragraph of lines(job.description)) {
        const p = document.createElement('p');
        p.textContent = paragraph;
        description.appendChild(p);
    }

    const skills = document.getElementById('job_skills');
    for (const skill of lines(job.skills)) {
        const li = document.createElement('li');
        li.innerHTML = '<svg class="icon" aria-hidden="true"><use href="#icon-check"/></svg>';
        li.append(skill);
        skills.appendChild(li);
    }

    const symbol = CURRENCY_SYMBOLS[job.currency] ?? '';
    document.getElementById('overview_title').textContent = job.title;
    document.getElementById('overview_type').textContent = job.job_type;
    document.getElementById('overview_category').textContent = job.category;
    document.getElementById('overview_experience').textContent = experienceText(job.experience);
    document.getElementById('overview_degree').textContent = job.degree;
    document.getElementById('overview_salary').textContent = `${symbol}${job.min_salary}-${symbol}${job.max_salary}`;
    document.getElementById('overview_location').textContent = `${job.city}, ${job.country}`;
}

async function loadJob() {
    if (!jobId) {
        showNotFound('No job was chosen.');
        return;
    }
    try {
        const response = await fetch(API_URL + '/api/jobs/' + encodeURIComponent(jobId));
        const data = await response.json();
        if (!response.ok) {
            showNotFound(data.detail);
            return;
        }
        showJob(data);
    } catch (error) {
        showNotFound('Could not reach the server. Is the backend running?');
    }
}

loadJob();
