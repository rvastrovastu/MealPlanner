import OpenAI from "openai";
import express from "express";
import cors from "cors";
import dotenv from "dotenv";

dotenv.config();
const openai = new OpenAI({
  apiKey: process.env.OPENAI_API_KEY
});

const app = express();
console.log("✅ Running updated MealPlanner server.js");

app.use(cors());
// FIX: default express.json() body limit is ~100kb, which is too small for
// base64-encoded photos sent to /api/ai/photo-calorie-scan. Bump it up.
app.use(express.json({ limit: "15mb" }));

app.get("/", (req, res) => {
  res.json({ message: "Meal Planner Backend Running 🚀" });
});

app.get("/api/test", (req, res) => {
  res.json({ message: "API Working 🚀" });
});

function buildPortion(householdSize, baseServing, maleServing, femaleServing, childServing) {
  return {
    totalFamilyQuantity: `${householdSize} servings`,
    perPersonServing: baseServing,
    maleAdultServing: maleServing,
    femaleAdultServing: femaleServing,
    childServing: childServing,
    maleAdultCalories: 600,
    femaleAdultCalories: 480,
    childCalories: 350
  };
}

function recipe(prepTime, cookTime, steps, tips) {
  return { prepTime, cookTime, steps, tips };
}

function createMeal(name, ingredients, calories, protein, carbs, fat, fiber, portion, recipeDetails) {
  return {
    name,
    ingredients,
    calories,
    protein,
    carbs,
    fat,
    fiber,
    portion,
    recipe: recipeDetails
  };
}

app.post("/api/meal-plan/generate", (req, res) => {
  const profile = req.body || {};
  const householdSize = profile.householdSize || 1;

  const portions = (base, male, female, child) =>
    buildPortion(householdSize, base, male, female, child);

  const snack = createMeal(
    "Roasted Makhana with Herbal Tea",
    ["Makhana", "Ghee", "Black Pepper", "Herbal Tea"],
    180,
    6,
    22,
    7,
    4,
    portions("1 bowl makhana", "1.5 bowls makhana", "1 bowl makhana", "0.5 bowl makhana"),
    recipe(
      "2 mins",
      "7 mins",
      [
        "Heat ghee in a pan.",
        "Add makhana and roast until crunchy.",
        "Add black pepper and light salt.",
        "Serve with herbal tea."
      ],
      "Good light snack for evening cravings."
    )
  );

  res.json({
    weekStartDate: profile.weekStartDate || "2026-06-08",
    numberOfWeeks: profile.numberOfWeeks || 1,
    days: [
      {
        day: "Monday",
        breakfast: createMeal(
          "Oats with Fruits",
          ["Oats", "Milk", "Banana", "Apple"],
          350,
          14,
          55,
          8,
          7,
          portions("1 bowl oats + fruit", "1.5 bowls oats + 1 banana", "1 bowl oats + 1 fruit", "0.5 bowl oats + fruit slices"),
          recipe("5 mins", "10 mins", ["Boil milk.", "Add oats and cook until soft.", "Top with fruit.", "Serve warm."], "Use boiled milk for creamier texture.")
        ),
        lunch: createMeal(
          "Dal, Brown Rice and Salad",
          ["Dal", "Brown Rice", "Cucumber", "Tomato"],
          600,
          25,
          80,
          14,
          12,
          portions("1 cup dal + 1 cup rice + salad", "1.5 cups dal + 1.5 cups rice + salad", "1 cup dal + 1 cup rice + salad", "0.5 cup dal + 0.5 cup rice + salad"),
          recipe("10 mins", "25 mins", ["Cook dal with turmeric.", "Cook brown rice.", "Prepare cucumber tomato salad.", "Serve together."], "Add a squeeze of lemon before serving.")
        ),
        eveningSnack: snack,
        dinner: createMeal(
          "Paneer Bhurji with Roti",
          ["Paneer", "Wheat Flour", "Tomato", "Spices"],
          520,
          28,
          48,
          22,
          8,
          portions("2 rotis + 1 cup paneer bhurji", "3 rotis + 1.5 cups paneer bhurji", "2 rotis + 1 cup paneer bhurji", "1 roti + 0.5 cup paneer bhurji"),
          recipe("10 mins", "20 mins", ["Crumble paneer.", "Cook tomato and spices.", "Add paneer and mix.", "Serve with roti."], "Use fresh paneer for best texture.")
        )
      },
      {
        day: "Tuesday",
        breakfast: createMeal("Besan Chilla with Curd", ["Besan", "Curd", "Spinach"], 330, 18, 38, 10, 6, portions("2 chillas + curd", "3 chillas + curd", "2 chillas + curd", "1 chilla + curd"), recipe("5 mins", "10 mins", ["Mix besan with water and spices.", "Add chopped spinach.", "Cook chillas on a pan.", "Serve with curd."], "Add a pinch of ajwain for digestion.")),
        lunch: createMeal("Rajma Rice", ["Rajma", "Rice", "Onion", "Tomato"], 620, 24, 85, 12, 13, portions("1 cup rajma + 1 cup rice", "1.5 cups rajma + 1.5 cups rice", "1 cup rajma + 1 cup rice", "0.5 cup rajma + 0.5 cup rice"), recipe("10 mins", "30 mins", ["Soak and cook rajma.", "Saute onion and tomato.", "Combine and simmer.", "Serve with rice."], "Soaking rajma overnight reduces cook time.")),
        eveningSnack: snack,
        dinner: createMeal("Veg Khichdi", ["Rice", "Moong Dal", "Vegetables"], 480, 20, 65, 10, 9, portions("1.5 bowls khichdi", "2 bowls khichdi", "1.5 bowls khichdi", "0.75 bowl khichdi"), recipe("5 mins", "20 mins", ["Wash rice and dal.", "Add chopped vegetables.", "Pressure cook until soft.", "Serve hot with ghee."], "A comforting, easy-to-digest dinner option."))
      },
      {
        day: "Wednesday",
        breakfast: createMeal("Poha with Peanuts", ["Poha", "Peanuts", "Peas"], 360, 12, 55, 11, 5, portions("1 bowl poha", "1.5 bowls poha", "1 bowl poha", "0.5 bowl poha"), recipe("5 mins", "10 mins", ["Rinse poha until soft.", "Saute peanuts and peas.", "Mix in poha with spices.", "Garnish and serve."], "Add lemon juice for extra flavor.")),
        lunch: createMeal("Chole with Roti", ["Chickpeas", "Wheat Flour", "Salad"], 610, 26, 78, 16, 14, portions("2 rotis + 1 cup chole", "3 rotis + 1.5 cups chole", "2 rotis + 1 cup chole", "1 roti + 0.5 cup chole"), recipe("10 mins", "25 mins", ["Cook soaked chickpeas.", "Prepare chole masala gravy.", "Combine and simmer.", "Serve with roti and salad."], "Pressure cooking chickpeas saves time.")),
        eveningSnack: snack,
        dinner: createMeal("Tofu Stir Fry", ["Tofu", "Bell Pepper", "Broccoli"], 500, 30, 45, 18, 10, portions("1.5 cups tofu stir fry", "2 cups tofu stir fry", "1.5 cups tofu stir fry", "0.75 cup tofu stir fry"), recipe("10 mins", "15 mins", ["Pan-fry tofu until golden.", "Stir fry vegetables.", "Combine with sauce.", "Serve hot."], "High protein, light dinner option."))
      },
      {
        day: "Thursday",
        breakfast: createMeal("Idli Sambar", ["Idli Batter", "Dal", "Vegetables"], 340, 15, 58, 5, 6, portions("3 idlis + sambar", "4 idlis + sambar", "3 idlis + sambar", "2 idlis + sambar"), recipe("5 mins", "15 mins", ["Steam idlis.", "Prepare sambar with vegetables.", "Serve idlis with sambar."], "Pair with coconut chutney if available.")),
        lunch: createMeal("Quinoa Pulao", ["Quinoa", "Mixed Vegetables", "Curd"], 570, 22, 70, 15, 11, portions("1.5 cups quinoa pulao", "2 cups quinoa pulao", "1.5 cups quinoa pulao", "0.75 cup quinoa pulao"), recipe("5 mins", "20 mins", ["Rinse quinoa.", "Saute vegetables with spices.", "Add quinoa and cook.", "Serve with curd."], "A lighter, high-fiber alternative to rice.")),
        eveningSnack: snack,
        dinner: createMeal("Dal Soup with Roti", ["Dal", "Wheat Flour", "Spinach"], 460, 23, 52, 12, 9, portions("2 rotis + 1 bowl soup", "3 rotis + 1.5 bowls soup", "2 rotis + 1 bowl soup", "1 roti + 0.5 bowl soup"), recipe("5 mins", "20 mins", ["Cook dal until soft.", "Blend into a soup consistency.", "Add spinach and simmer.", "Serve with roti."], "Light and easy on the stomach for dinner."))
      },
      {
        day: "Friday",
        breakfast: createMeal("Greek Yogurt Bowl", ["Greek Yogurt", "Berries", "Seeds"], 320, 22, 35, 8, 6, portions("1 bowl yogurt + berries", "1.5 bowls yogurt + berries", "1 bowl yogurt + berries", "0.5 bowl yogurt + berries"), recipe("5 mins", "0 mins", ["Layer yogurt in a bowl.", "Top with berries and seeds.", "Serve chilled."], "No cooking needed, great for busy mornings.")),
        lunch: createMeal("Veg Biryani with Raita", ["Rice", "Vegetables", "Curd"], 650, 20, 90, 18, 9, portions("1.5 cups biryani + raita", "2 cups biryani + raita", "1.5 cups biryani + raita", "0.75 cup biryani + raita"), recipe("15 mins", "30 mins", ["Saute vegetables and spices.", "Layer with par-cooked rice.", "Dum cook until done.", "Serve with raita."], "Letting it rest 10 minutes improves flavor.")),
        eveningSnack: snack,
        dinner: createMeal("Mixed Veg with Dal", ["Vegetables", "Dal", "Roti"], 500, 24, 58, 14, 10, portions("2 rotis + dal + vegetables", "3 rotis + dal + vegetables", "2 rotis + dal + vegetables", "1 roti + dal + vegetables"), recipe("10 mins", "20 mins", ["Cook dal separately.", "Saute mixed vegetables.", "Combine and season.", "Serve with roti."], "A balanced, well-rounded dinner."))
      },
      {
        day: "Saturday",
        breakfast: createMeal("Upma", ["Rava", "Vegetables", "Peanuts"], 370, 12, 58, 10, 6, portions("1 bowl upma", "1.5 bowls upma", "1 bowl upma", "0.5 bowl upma"), recipe("5 mins", "15 mins", ["Roast rava lightly.", "Saute vegetables and peanuts.", "Add water and cook rava.", "Serve hot."], "Roasting rava first prevents lumps.")),
        lunch: createMeal("Paneer Wrap", ["Paneer", "Whole Wheat Wrap", "Lettuce"], 590, 30, 55, 22, 8, portions("1 paneer wrap", "1.5 paneer wraps", "1 paneer wrap", "0.5 paneer wrap"), recipe("10 mins", "15 mins", ["Cook spiced paneer filling.", "Warm the wrap.", "Add lettuce and filling.", "Roll and serve."], "Great for a quick, portable lunch.")),
        eveningSnack: snack,
        dinner: createMeal("Millet Dosa", ["Millet Batter", "Chutney", "Sambar"], 490, 18, 65, 12, 9, portions("2 dosas + sambar", "3 dosas + sambar", "2 dosas + sambar", "1 dosa + sambar"), recipe("5 mins", "15 mins", ["Heat a dosa pan.", "Spread millet batter thin.", "Cook until crisp.", "Serve with chutney and sambar."], "A gluten-free alternative to wheat dosas."))
      },
      {
        day: "Sunday",
        breakfast: createMeal("Paratha with Curd", ["Wheat Flour", "Curd", "Vegetables"], 420, 16, 60, 13, 7, portions("1 paratha + curd", "1.5 parathas + curd", "1 paratha + curd", "0.5 paratha + curd"), recipe("10 mins", "15 mins", ["Prepare vegetable stuffing.", "Stuff and roll the paratha.", "Cook on a hot pan with ghee.", "Serve with curd."], "A hearty weekend breakfast option.")),
        lunch: createMeal("Family Thali", ["Dal", "Rice", "Roti", "Vegetables", "Salad"], 700, 30, 95, 18, 14, portions("1 thali", "1.5 thalis", "1 thali", "0.5 thali"), recipe("20 mins", "40 mins", ["Prepare dal, rice and roti.", "Cook a vegetable side.", "Assemble salad.", "Serve as a complete thali."], "A great option for a relaxed family meal.")),
        eveningSnack: snack,
        dinner: createMeal("Light Lentil Soup", ["Lentils", "Vegetables", "Toast"], 430, 22, 48, 10, 10, portions("1 bowl soup + toast", "1.5 bowls soup + toast", "1 bowl soup + toast", "0.5 bowl soup + toast"), recipe("5 mins", "20 mins", ["Cook lentils with vegetables.", "Blend to desired consistency.", "Toast bread.", "Serve soup with toast."], "Light way to end the week."))
      }
    ],
    groceryList: {
      vegetables: ["Spinach", "Tomato", "Cucumber", "Bell Pepper", "Broccoli", "Mixed Vegetables"],
      fruits: ["Banana", "Apple", "Berries"],
      grains: ["Oats", "Brown Rice", "Rice", "Wheat Flour", "Quinoa", "Millets", "Rava"],
      protein: ["Dal", "Paneer", "Tofu", "Rajma", "Chickpeas", "Lentils"],
      dairy: ["Milk", "Curd", "Greek Yogurt"],
      spices: ["Turmeric", "Cumin", "Coriander", "Garam Masala"],
      others: ["Peanuts", "Seeds", "Whole Wheat Wrap", "Makhana", "Herbal Tea"]
    }
  });
});

app.post("/api/ai/meal-swap", async (req, res) => {
  try {
    const { mealName, dietType, restrictions, goal } = req.body || {};

    const prompt = `
Suggest 3 healthier meal swaps.

Original meal: ${mealName}
Diet type: ${dietType}
Restrictions: ${(restrictions || []).join(", ")}
Goal: ${goal}
Return JSON only:
{
  "originalMeal": "...",
  "swaps": [
    {
      "name": "...",
      "calories": 400,
      "protein": 20,
      "carbs": 40,
      "fat": 12,
      "fiber": 8,
      "reason": "..."
    }
  ]
}
`;
    const completion = await openai.chat.completions.create({
      model: "gpt-4.1-mini",
      messages: [{ role: "user", content: prompt }],
      temperature: 0.7,
      response_format: { type: "json_object" }
    });

    const result = JSON.parse(completion.choices[0].message.content);
    res.json(result);
  } catch (error) {
    console.error("Meal swap error:", error);
    res.status(500).json({
      originalMeal: req.body?.mealName || "Selected Meal",
      swaps: []
    });
  }
});

app.post("/api/ai/nutrition-coach", async (req, res) => {
  try {
    const { question, profile } = req.body || {};

    const prompt = `
You are a helpful nutrition coach inside a family meal planning app.

User Profile:
${JSON.stringify(profile || {}, null, 2)}

Question:
${question}

Give practical, safe, family-friendly nutrition advice.

Keep answer short.
Return JSON only:
{
  "answer": "...",
  "suggestions": ["...", "...", "..."]
}
`;

    const completion = await openai.chat.completions.create({
      model: "gpt-4.1-mini",
      messages: [{ role: "user", content: prompt }],
      temperature: 0.6,
      response_format: { type: "json_object" }
    });

    const result = JSON.parse(completion.choices[0].message.content);
    res.json(result);
  } catch (error) {
    console.error("AI Coach error:", error);
    res.status(500).json({
      answer: "AI coach is temporarily unavailable.",
      suggestions: [
        "Try again later",
        "Keep meals balanced",
        "Add protein and fiber"
      ]
    });
  }
});

app.post("/api/ai/leftover-recipe", async (req, res) => {
  try {
    const { leftoverName, quantity, dietType } = req.body || {};

    const prompt = `
Suggest 3 creative recipes using leftover food.

Leftover: ${leftoverName}
Quantity: ${quantity}
Diet: ${dietType}

Return JSON only:
{
  "ideas": [
    {
      "name": "...",
      "description": "...",
      "calories": 300,
      "steps": ["..."]
    }
  ]
}
`;

    const completion = await openai.chat.completions.create({
      model: "gpt-4.1-mini",
      messages: [{ role: "user", content: prompt }],
      temperature: 0.7,
      response_format: { type: "json_object" }
    });

    res.json(JSON.parse(completion.choices[0].message.content));
  } catch (error) {
    console.error("Leftover recipe error:", error);
    res.status(500).json({ ideas: [] });
  }
});

app.post("/api/ai/pantry-recipe", async (req, res) => {
  try {
    const { pantryItems, dietType, restrictions } = req.body || {};

    const prompt = `
Create 3 recipes using these pantry items:
${JSON.stringify(pantryItems || [])}

Diet type: ${dietType}
Restrictions: ${(restrictions || []).join(", ")}

Return JSON only:
{
  "recipes": [
    {
      "name": "...",
      "calories": 400,
      "protein": 20,
      "ingredients": ["..."],
      "steps": ["..."],
      "reason": "..."
    }
  ]
}
`;

    const completion = await openai.chat.completions.create({
      model: "gpt-4.1-mini",
      messages: [{ role: "user", content: prompt }],
      temperature: 0.7,
      response_format: { type: "json_object" }
    });

    res.json(JSON.parse(completion.choices[0].message.content));
  } catch (error) {
    console.error("Pantry recipe error:", error);
    res.status(500).json({ recipes: [] });
  }
});

app.post("/api/ai/craving-alternative", async (req, res) => {
  try {
    const { craving, dietType, goal, restrictions } = req.body || {};

    const prompt = `
Suggest 3 healthier alternatives.

Craving: ${craving}
Diet Type: ${dietType}
Goal: ${goal}
Restrictions: ${(restrictions || []).join(", ")}

Return JSON only:

{
  "craving": "${craving}",
  "alternatives": [
    {
      "name": "...",
      "calories": 200,
      "protein": 10,
      "carbs": 20,
      "fat": 8,
      "reason": "..."
    }
  ]
}
`;

    const completion = await openai.chat.completions.create({
      model: "gpt-4.1-mini",
      messages: [{ role: "user", content: prompt }],
      temperature: 0.7,
      response_format: { type: "json_object" }
    });

    res.json(JSON.parse(completion.choices[0].message.content));
  } catch (error) {
    console.error("Craving alternative error:", error);
    res.status(500).json({
      craving: req.body?.craving || "",
      alternatives: []
    });
  }
});

// SMART GROCERY INTEGRATIONS

const storeSearchUrls = {
  walmart: "https://www.walmart.com/search?q=",
  instacart: "https://www.instacart.com/store/s?k=",
  amazonFresh: "https://www.amazon.com/s?k="
};

function normalizeGroceryItems(items = []) {
  // FIX: guard against non-array input so callers get a clean error
  // instead of a 500 from .map() on undefined.
  if (!Array.isArray(items)) return [];
  return items.map(item => ({
    name: item.name || item,
    quantity: item.quantity || "1",
    category: item.category || "General",
    estimatedPrice: item.estimatedPrice || 0,
    pantryAvailable: item.pantryAvailable || false
  }));
}

// Generate store shopping links
app.post("/api/grocery/store-links", (req, res) => {
  const { items } = req.body || {};

  // FIX: validate input before processing
  if (!Array.isArray(items) || items.length === 0) {
    return res.status(400).json({ error: "items array is required" });
  }

  const groceryItems = normalizeGroceryItems(items);

  const links = groceryItems.map(item => {
    const query = encodeURIComponent(item.name);

    return {
      name: item.name,
      quantity: item.quantity,
      walmart: storeSearchUrls.walmart + query,
      instacart: storeSearchUrls.instacart + query,
      amazonFresh: storeSearchUrls.amazonFresh + query
    };
  });

  res.json({ links });
});

// Export grocery list
app.post("/api/grocery/export", (req, res) => {
  const { items } = req.body || {};

  if (!Array.isArray(items) || items.length === 0) {
    return res.status(400).json({ error: "items array is required" });
  }

  const groceryItems = normalizeGroceryItems(items);

  const text = groceryItems
    .map(item => `- ${item.quantity} ${item.name}`)
    .join("\n");

  res.json({
    title: "Digital Dine Grocery List",
    text
  });
});

// Pantry deduction
app.post("/api/grocery/pantry-deduction", (req, res) => {
  const { groceryItems, pantryItems } = req.body || {};

  // FIX: previously this crashed with a 500 if either array was missing.
  if (!Array.isArray(groceryItems) || !Array.isArray(pantryItems)) {
    return res.status(400).json({ error: "groceryItems and pantryItems arrays are required" });
  }

  const pantryNames = pantryItems.map(p => (p.name || "").toLowerCase());

  const result = groceryItems.map(item => {
    const inPantry = pantryNames.includes((item.name || "").toLowerCase());

    return {
      ...item,
      pantryAvailable: inPantry,
      needToBuy: !inPantry
    };
  });

  res.json({
    needToBuy: result.filter(i => i.needToBuy),
    alreadyInPantry: result.filter(i => i.pantryAvailable)
  });
});

// Estimated cost by store
app.post("/api/grocery/cost-estimate", (req, res) => {
  const { items } = req.body || {};

  if (!Array.isArray(items) || items.length === 0) {
    return res.status(400).json({ error: "items array is required" });
  }

  const groceryItems = normalizeGroceryItems(items);

  const baseTotal = groceryItems.reduce((sum, item) => {
    return sum + Number(item.estimatedPrice || 3.5);
  }, 0);

  res.json({
    walmart: Number((baseTotal * 0.95).toFixed(2)),
    instacart: Number((baseTotal * 1.12).toFixed(2)),
    amazonFresh: Number((baseTotal * 1.05).toFixed(2))
  });
});

// Need to buy checklist
app.post("/api/grocery/need-to-buy", (req, res) => {
  const { items } = req.body || {};

  if (!Array.isArray(items) || items.length === 0) {
    return res.status(400).json({ error: "items array is required" });
  }

  const groceryItems = normalizeGroceryItems(items);

  res.json({
    checklist: groceryItems
      .filter(item => !item.pantryAvailable)
      .map(item => ({
        name: item.name,
        quantity: item.quantity,
        checked: false
      }))
  });
});

// ADVANCED GROCERY FEATURES

app.post("/api/grocery/coupons", (req, res) => {
  const { items } = req.body || {};

  if (!Array.isArray(items) || items.length === 0) {
    return res.status(400).json({ error: "items array is required" });
  }

  const groceryItems = normalizeGroceryItems(items);

  const coupons = groceryItems.map(item => ({
    item: item.name,
    store: "Walmart",
    title: `Possible savings on ${item.name}`,
    description: `Check weekly deals or store coupons for ${item.name}.`,
    estimatedSavings: Number(((item.estimatedPrice || 0) * 0.10 || 0.5).toFixed(2))
  }));

  res.json({ coupons });
});

app.post("/api/grocery/budget-optimize", async (req, res) => {
  const { budget, items, dietType, goal } = req.body || {};

  if (!Array.isArray(items) || items.length === 0) {
    return res.status(400).json({ error: "items array is required" });
  }

  const groceryItems = normalizeGroceryItems(items);

  const totalCost = groceryItems.reduce((sum, item) => {
    return sum + Number(item.estimatedPrice || 3.5);
  }, 0);

  try {
    const prompt = `
You are an AI grocery budget optimizer.

Budget: $${budget}
Current estimated cost: $${totalCost}
Diet Type: ${dietType || "Any"}
Goal: ${goal || "Save money"}

Grocery items:
${JSON.stringify(groceryItems)}

Return JSON only:
{
  "budget": ${Number(budget || 0)},
  "currentEstimatedCost": ${Number(totalCost || 0)},
  "estimatedSavings": 0,
  "isWithinBudget": true,
  "recommendations": [
    {
      "item": "...",
      "suggestion": "...",
      "reason": "...",
      "estimatedSavings": 0
    }
  ]
}
`;

    const completion = await openai.chat.completions.create({
      model: "gpt-4.1-mini",
      messages: [{ role: "user", content: prompt }],
      temperature: 0.6,
      response_format: { type: "json_object" }
    });

    res.json(JSON.parse(completion.choices[0].message.content));
  } catch (error) {
    console.error("Budget optimizer error:", error.message || error);

    res.json({
      budget: Number(budget || 0),
      currentEstimatedCost: Number(totalCost.toFixed(2)),
      estimatedSavings: Number((totalCost * 0.12).toFixed(2)),
      isWithinBudget: totalCost <= Number(budget || 0),
      recommendations: groceryItems.map(item => ({
        item: item.name,
        suggestion: `Compare prices for ${item.name} at Walmart, Instacart, and Amazon Fresh.`,
        reason: "Fallback savings recommendation generated when AI is unavailable.",
        estimatedSavings: Number(((item.estimatedPrice || 3.5) * 0.10).toFixed(2))
      }))
    });
  }
});

// FIX: there were TWO definitions of this route in the original file.
// Express silently ignores the second one, so it was dead code. Merged
// into a single route that keeps the sensible defaults from the second
// version.
app.post("/api/party/generate-menu", (req, res) => {
  try {
    const {
      eventType = "Family Dinner",
      guestCount = 10,
      cuisine = "Indian",
      dietType = "Vegetarian",
      budget = 200
    } = req.body || {};

    const guests = Number(guestCount) || 10;
    const totalBudget = Number(budget) || 200;
    const perGuestCost = guests > 0 ? totalBudget / guests : 0;

    res.json({
      eventType,
      guestCount: guests,
      cuisine,
      dietType,
      budget: totalBudget,
      expectedCost: totalBudget,
      perGuestCost: Number(perGuestCost.toFixed(2)),
      menu: {
        starter: ["Paneer Tikka", "Veg Cutlet", "Masala Papad"],
        mainCourse: ["Dal Makhani", "Paneer Butter Masala", "Veg Pulao", "Naan / Roti"],
        dessert: ["Gulab Jamun", "Fruit Custard"],
        drinks: ["Masala Chaas", "Lemonade"]
      },
      groceryList: {
        costco: ["Rice bulk pack", "Milk", "Disposable plates", "Drinks", "Dessert supplies"],
        indianStore: ["Paneer", "Dal", "Spices", "Naan / Roti", "Makhana"],
        walmart: ["Vegetables", "Salad items", "Napkins", "Cups", "Water bottles"]
      },
      quantityEstimate: {
        rice: `${Math.ceil(guests * 0.25)} cups`,
        rotiNaan: `${guests * 2} pieces`,
        curry: `${Math.ceil(guests / 5)} large trays`,
        dessert: `${guests} servings`,
        drinks: `${Math.ceil(guests * 1.5)} servings`
      }
    });
  } catch (error) {
    console.error("Party planner error:", error);
    res.status(500).json({ error: "Unable to generate party plan" });
  }
});

app.post("/api/ai/photo-calorie-scan", async (req, res) => {
  try {
    const { imageBase64 } = req.body || {};

    if (!imageBase64) {
      return res.status(400).json({
        error: "imageBase64 is required"
      });
    }

    // FIX: OpenAI's vision API requires a full data URI
    // (data:image/<type>;base64,<data>). If the client sent raw base64
    // without the prefix, this previously failed silently/threw.
    // Default to image/jpeg if no prefix is present.
    const imageUrl = imageBase64.startsWith("data:")
      ? imageBase64
      : `data:image/jpeg;base64,${imageBase64}`;

    const completion = await openai.chat.completions.create({
      model: "gpt-4.1-mini",
      messages: [
        {
          role: "user",
          content: [
            {
              type: "text",
              text: `
Analyze this food image and estimate calories.
Return JSON only:
{
  "foodName": "...",
  "estimatedCalories": 400,
  "protein": 20,
  "carbs": 45,
  "fat": 12,
  "confidence": "Low / Medium / High",
  "notes": "..."
}

Be conservative. Mention uncertainty if portion size is unclear.
`
            },
            {
              type: "image_url",
              image_url: {
                url: imageUrl
              }
            }
          ]
        }
      ],
      temperature: 0.3,
      response_format: { type: "json_object" }
    });

    res.json(JSON.parse(completion.choices[0].message.content));
  } catch (error) {
    console.error("Photo calorie scan error:", error);
    res.status(500).json({
      foodName: "Unknown food",
      estimatedCalories: 0,
      protein: 0,
      carbs: 0,
      fat: 0,
      confidence: "Low",
      notes: "Unable to scan image right now."
    });
  }
});

app.use((req, res) => {
  res.status(404).json({
    error: "Route not found",
    path: req.originalUrl
  });
});

const PORT = process.env.PORT || 5001;

app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});

