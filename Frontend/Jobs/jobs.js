// Create Job button: only shown to admins (the backend still checks the role when saving a job)
if (getUser()?.role === 'admin') document.getElementById('create_job_btn').hidden = false;

function make_icon(id) {
  const NS = "http://www.w3.org/2000/svg";
  const svg = document.createElementNS(NS, "svg");
  svg.classList.add("icon");
  const use = document.createElementNS(NS, "use");
  use.setAttribute("href", "#" + id);
  svg.appendChild(use);
  return svg;
}
// Removes the job from the database; the home page reads from the database, so it disappears there too
async function delete_job(job, card) {
  if (!confirm(`Delete "${job.title}" (${job.company})? This cannot be undone.`)) return;
  try {
    const response = await apiFetch(`/api/jobs/${encodeURIComponent(job.id)}`, { method: "DELETE" });
    // 404 means someone already deleted it, so the card should go away as well
    if (response.ok || response.status === 404) {
      card.remove();
      paginate(current_page);
    } else {
      const data = await response.json();
      alert(data.detail);
    }
  } catch (error) {
    alert("Could not reach the server. Is the backend running?");
  }
}

let jobs = document.getElementById("jobs");
// One card builder for every list (all jobs, filters, search from the home page), so they all get the same link and admin buttons
function make_card(i){
        const art=document.createElement("article");
        art.classList.add("job_card");
        const div=document.createElement("div");
        div.classList.add("card_top");
        const span=document.createElement("span");
        span.classList.add("time_tag");
        const added_time=new Date(i.added_time);
        const now=new Date();
        let diff=now - added_time;
        if(diff<1000 && diff>=0){
          span.textContent = "Just now";
        }
        else if(diff>=1000 && diff<60000){
          diff = Math.floor(diff/1000);
          span.textContent=`${diff} s ago`;
        }
        else if(diff>=60000 && diff<3600000){
          diff=Math.floor(diff/60000);
          span.textContent=`${diff} min(s) ago`;
        }
        else if(diff>=3600000 && diff<86400000){
          diff=Math.floor(diff/3600000);
          span.textContent=`${diff} hour(s) ago`;
        }
        else if(diff>=86400000 && diff<2592000000){
          diff=Math.floor(diff/86400000);
          span.textContent = `${diff} day(s) ago`;
        }
        else if(diff>=2592000000 && diff<31536000000){
          diff=Math.floor(diff/2592000000);
          span.textContent = `${diff} Month(s) ago`;
        }
        else{
          diff=Math.floor(diff/31536000000);
          span.textContent = `${diff} year(s) ago`;
        }

        
        div.appendChild(span);
        // Edit pencil: only admins see it; saving the changes is checked again on the backend
        if (getUser()?.role === "admin") {
          const edit_btn = document.createElement("a");
          edit_btn.classList.add("edit_btn");
          edit_btn.href = `../Admin/create_job.html?id=${encodeURIComponent(i.id)}`;
          edit_btn.setAttribute("aria-label", `Edit job ${i.title}`);
          edit_btn.appendChild(make_icon("icon-pencil"));
          div.appendChild(edit_btn);
        }
        art.appendChild(div);
        const job_title = document.createElement("h3");
        job_title.textContent=i.title;
        art.appendChild(job_title);
        const name_company = document.createElement("p");
        name_company.classList.add("company");
        name_company.textContent = i.company;
        art.appendChild(name_company);
        const card_btm = document.createElement("div");
        card_btm.classList.add("card_bottom");
        const job_infos = document.createElement("ul");
        job_infos.classList.add("job_info");
        const job_infos_items = document.createElement("li");
        job_infos_items.appendChild(make_icon("icon-briefcase"));
        job_infos_items.append(i.category);
        job_infos.appendChild(job_infos_items);
        const list_items = document.createElement("li");
        list_items.appendChild(make_icon("icon-clock"));
        list_items.append(i.job_type);
        job_infos.appendChild(list_items);
        const list_wallet = document.createElement("li");
        list_wallet.appendChild(make_icon("icon-wallet"));
        list_wallet.append(`${i.min_salary}-${i.max_salary}`);
        job_infos.appendChild(list_wallet);
        const li_location = document.createElement("li");
        li_location.appendChild(make_icon("icon-pin"));
        li_location.append(`${i.country}, ${i.city}`);
        job_infos.appendChild(li_location);
        card_btm.appendChild(job_infos);
        const card_actions = document.createElement("div");
        card_actions.classList.add("card_actions");
        if (getUser()?.role === "admin") {
          const delete_btn = document.createElement("button");
          delete_btn.classList.add("btn", "btn_delete");
          delete_btn.textContent = "Delete";
          delete_btn.setAttribute("aria-label", `Delete job ${i.title}`);
          delete_btn.addEventListener("click", () => delete_job(i, art));
          card_actions.appendChild(delete_btn);
        }
        const a_btn = document.createElement("a");
        a_btn.setAttribute("href", `../JobDetails/job_details.html?id=${encodeURIComponent(i.id)}`);
        a_btn.classList.add("btn");
        a_btn.textContent = "Job Details";
        card_actions.appendChild(a_btn);
        card_btm.appendChild(card_actions);
        art.appendChild(card_btm);
        return art;
}

async function get_all_jobs(){
      let response = await fetch("http://127.0.0.1:8000/api/jobs");
      if(response.ok){
        const recent_jobs = await response.json();
        display_cards("jobs", recent_jobs.cards_data);
      }
      else{
        alert("Error");
      }
  }

const PAGE_SIZE = 5;
let current_page = 1;
// shortcut: every job is loaded and the cards outside the page are hidden; move to LIMIT/OFFSET in the API if there are thousands of jobs
function paginate(page) {
  const cards = document.querySelectorAll("#jobs .job_card");
  const total_pages = Math.max(1, Math.ceil(cards.length / PAGE_SIZE));
  current_page = Math.min(Math.max(page, 1), total_pages);
  const start = (current_page - 1) * PAGE_SIZE;
  cards.forEach((card, index) => card.hidden = index < start || index >= start + PAGE_SIZE);
  document.getElementById("results_count").textContent = cards.length
    ? `Showing ${start + 1}-${Math.min(start + PAGE_SIZE, cards.length)} of ${cards.length} results`
    : "No jobs found";
  document.getElementById("page_info").textContent = `Page ${current_page} of ${total_pages}`;
  document.getElementById("prev_page").disabled = current_page === 1;
  document.getElementById("next_page").disabled = current_page === total_pages;
}
document.getElementById("prev_page").addEventListener("click", () => paginate(current_page - 1));
document.getElementById("next_page").addEventListener("click", () => paginate(current_page + 1));
  
  let list_location = document.getElementById("location_select");
    async function charge_locations() {
        let response = await fetch("http://127.0.0.1:8000/api/locations_HomePage");
        if(response.ok){
            const data_locations = await response.json();
            console.log(data_locations);
            for(const i of data_locations.locations){
                let location = document.createElement("option");
                location.textContent = i.country;
                location.value=i.id_country;
                list_location.appendChild(location);
            }
        }
        else{
          alert("Error");
        }
    }
  
  let list_category = document.getElementById("category_select");
  async function charge_categories() {
      let response = await fetch("http://127.0.0.1:8000/api/categories_HomePage");
      if(response.ok){
          const data= await response.json();
          console.log(data);
          let count=0;
          for(const i of data.categories){
              count++;
              let list_item=document.createElement("li");
              let label = document.createElement("label");
              let input = document.createElement("input");
              input.setAttribute("type","checkbox");
              input.value = i.id;
              let span = document.createElement("span");
              span.setAttribute("class","count");
              label.appendChild(input);
              label.append(i.name);
              span.append(10);
              list_item.appendChild(label);
              list_item.appendChild(span);
              list_category.appendChild(list_item);
            if(count>5){
              list_item.setAttribute("class","extra");
              list_item.setAttribute("hidden","");
            }
        }
      } 

      else{
        alert("Error");
      }
    }
  function btn_show_more(){
    let btn = document.getElementById("show_more");
    btn.addEventListener("click",function(){
      const li = document.querySelectorAll("#category_select li.extra");
      for(const i of li){
        if(i.hidden == true){
          i.hidden=false;
          btn.textContent="Show Less";
        }
        else{
          btn.textContent="Show More";
          i.hidden=true;
        }
      }
    });
  }
  btn_show_more();
  let list_job_title = document.getElementById("job_title_select");
  async function charge_job_titles(){
      let response = await fetch("http://127.0.0.1:8000/api/job_titles");
      if(response.ok){
        const title_jobs = await response.json();
        console.log(title_jobs);
        for(const i of title_jobs.job_titles){
            let element = document.createElement("option")
            element.textContent = i.title;
            element.value= i.id;
            list_job_title.appendChild(element);
        }

      }
      else{
        alert("Error");
      }
  } 

async function get_filters(){
  let filters_aside = document.getElementById("filters");
  filters_aside.addEventListener("change", function(){
    search_jobs();
  });
}
get_filters();
async function search_jobs() {
    let categories = document.querySelectorAll('#category_select input[type="checkbox"]');
    let job_types = document.querySelectorAll('#job_type input[type="checkbox"]');
    let degrees = document.querySelectorAll('#degree input[type="checkbox"]');
    let dates = document.querySelectorAll('#date_posted input[type="checkbox"]');

    let categories_selected = [];
    let job_types_selected = [];
    let degrees_selected = [];
    let dates_selected = [];

    for (const i of categories) {
        if (i.checked) {
            categories_selected.push(i.value);
        }
    }

    for (const i of job_types) {
        if (i.checked) {
            job_types_selected.push(i.value);
        }
    }

    for (const i of degrees) {
        if (i.checked) {
            degrees_selected.push(i.value);
        }
    }

    for (const i of dates) {
        if (i.checked) {
            dates_selected.push(i.value);
        }
    }

    let location = document.getElementById("location_select").value;
    let jt = document.getElementById("job_title_select").value;

    let params = new URLSearchParams({
        id_country: location,
        id_category: categories_selected.join(","),
        job_title: jt,
        date_posted: dates_selected.join(","),
        job_type: job_types_selected.join(","),
        degree: degrees_selected.join(",")
    });
 

    let url = `http://127.0.0.1:8000/api/filters_jobs?${params}`;
    console.log(url);
    let response = await fetch(url);
    if(response.ok){
      let data = await response.json();
      display_cards("jobs",data.filters);
    }
    else{
      alert("Error");
    }
        
}

function display_cards(id_container,jobs){
      const section = document.getElementById(id_container);
      section.innerHTML = "";
      for(const i of jobs){
        section.appendChild(make_card(i));
      }
      paginate(1);
}
async function read_filters_homePage(){
  const params = window.location.search;
  const objet = new URLSearchParams(params);
  let category_url = objet.get("category");
  let location_url = objet.get("location");
  let jt_url = objet.get("job_titles");
  if(category_url === null)
    category_url = "";  
  if(location_url === null)
    location_url = "";
  if(jt_url === null)
    jt_url="";
  let location_select = document.getElementById("location_select");
  let job_title = document.getElementById("job_title_select");
  let category_values = document.querySelectorAll("#category_select input");
  for (const i of category_values){
    if(i.value === category_url)
      i.checked = true;
  }
  
  location_select.value = location_url;
  job_title.value = jt_url;

  let url = `http://127.0.0.1:8000/api/filters_homePage?category=${category_url}&location=${location_url}&job_titles=${jt_url}`;
  let response = await fetch(url);
  if(response.ok){
    let data = await  response.json();
    display_cards("jobs",data.filters_homePage);
  }
  else{
    alert("Error");
  }
}

async function initialiser_page(){
  await charge_locations();
  await charge_categories();
  await charge_job_titles();
  const params = new URLSearchParams(window.location.search);
const hasFilters =
    params.has("category") ||
    params.has("location") ||
    params.has("job_titles");
if(hasFilters){
  await read_filters_homePage();
}
else{
  await get_all_jobs();

}
}
initialiser_page();