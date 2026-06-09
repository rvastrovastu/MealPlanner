import OpenAI from "openai";
import express from "express";
import cors from "cors";
import dotenv from "dotenv";

dotenv.config();
const openai = new OpenAI({
  apiKey: process.env.OPENAI_API_KEY
});

const app = express();

app.use(cors());
app.use(express.json());

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
          recipe("5 mins", "10 mins", ["Boil milk.", "Add oats and cook until soft.", "Top with fruit.", "Serve warm."], "Use berries instead of banana for low sugar.")
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
          recipe("10 mins", "25 mins", ["Cook dal with turmeric.", "Cook brown rice.", "Prepare cucumber tomato salad.", "Serve together."], "Add lemon for taste.")
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
          recipe("10 mins", "20 mins", ["Crumble paneer.", "Cook tomato and spices.", "Add paneer and mix.", "Serve with roti."], "Use less oil for lighter dinner.")
        )
      },
      {
        day: "Tuesday",
        breakfast: createMeal("Besan Chilla with Curd", ["Besan", "Curd", "Spinach"], 330, 18, 38, 10, 6, portions("2 chillas + curd", "3 chillas + 1 cup curd", "2 chillas + 0.75 cup curd", "1 chilla + 0.5 cup curd"), recipe("8 mins", "12 mins", ["Mix besan with water.", "Add spinach and spices.", "Cook chilla on pan.", "Serve with curd."], "Add grated vegetables for more fiber.")),
        lunch: createMeal("Rajma Rice", ["Rajma", "Rice", "Onion", "Tomato"], 620, 24, 85, 12, 13, portions("1 cup rajma + 1 cup rice", "1.5 cups rajma + 1.5 cups rice", "1 cup rajma + 1 cup rice", "0.5 cup rajma + 0.5 cup rice"), recipe("15 mins", "35 mins", ["Cook soaked rajma.", "Prepare onion tomato masala.", "Mix rajma with masala.", "Serve with rice."], "Use brown rice for more fiber.")),
        eveningSnack: snack,
        dinner: createMeal("Veg Khichdi", ["Rice", "Moong Dal", "Vegetables"], 480, 20, 65, 10, 9, portions("1.5 bowls khichdi", "2 bowls khichdi", "1.5 bowls khichdi", "1 bowl khichdi"), recipe("10 mins", "25 mins", ["Wash rice and dal.", "Add vegetables.", "Pressure cook.", "Serve warm."], "Good light dinner option."))
      },
      {
        day: "Wednesday",
        breakfast: createMeal("Poha with Peanuts", ["Poha", "Peanuts", "Peas"], 360, 12, 55, 11, 5, portions("1 bowl poha", "1.5 bowls poha", "1 bowl poha", "0.75 bowl poha"), recipe("8 mins", "12 mins", ["Rinse poha.", "Cook peas and spices.", "Add poha.", "Top with peanuts."], "Add lemon and coriander.")),
        lunch: createMeal("Chole with Roti", ["Chickpeas", "Wheat Flour", "Salad"], 610, 26, 78, 16, 14, portions("2 rotis + 1 cup chole", "3 rotis + 1.5 cups chole", "2 rotis + 1 cup chole", "1 roti + 0.5 cup chole"), recipe("15 mins", "35 mins", ["Cook chickpeas.", "Prepare masala.", "Simmer chole.", "Serve with roti."], "Add salad for better digestion.")),
        eveningSnack: snack,
        dinner: createMeal("Tofu Stir Fry", ["Tofu", "Bell Pepper", "Broccoli"], 500, 30, 45, 18, 10, portions("1.5 cups tofu stir fry", "2 cups tofu stir fry", "1.5 cups tofu stir fry", "1 cup tofu stir fry"), recipe("10 mins", "15 mins", ["Cube tofu.", "Stir fry vegetables.", "Add tofu.", "Season and serve."], "High protein dinner."))
      },
      {
        day: "Thursday",
        breakfast: createMeal("Idli Sambar", ["Idli Batter", "Dal", "Vegetables"], 340, 15, 58, 5, 6, portions("3 idlis + sambar", "4 idlis + 1.5 cups sambar", "3 idlis + 1 cup sambar", "2 idlis + 0.5 cup sambar"), recipe("5 mins", "20 mins", ["Steam idlis.", "Cook sambar dal.", "Add vegetables.", "Serve hot."], "Use less oil in tempering.")),
        lunch: createMeal("Quinoa Pulao", ["Quinoa", "Mixed Vegetables", "Curd"], 570, 22, 70, 15, 11, portions("1.5 cups quinoa pulao + curd", "2 cups quinoa pulao + 1 cup curd", "1.5 cups quinoa pulao + 0.75 cup curd", "1 cup quinoa pulao + 0.5 cup curd"), recipe("10 mins", "20 mins", ["Wash quinoa.", "Saute vegetables.", "Cook quinoa with spices.", "Serve with curd."], "Good high-fiber lunch.")),
        eveningSnack: snack,
        dinner: createMeal("Dal Soup with Roti", ["Dal", "Wheat Flour", "Spinach"], 460, 23, 52, 12, 9, portions("2 rotis + 1 bowl dal soup", "3 rotis + 1.5 bowls soup", "2 rotis + 1 bowl soup", "1 roti + 0.75 bowl soup"), recipe("10 mins", "25 mins", ["Cook dal.", "Blend lightly.", "Add spinach.", "Serve with roti."], "Light and protein-rich."))
      },
      {
        day: "Friday",
        breakfast: createMeal("Greek Yogurt Bowl", ["Greek Yogurt", "Berries", "Seeds"], 320, 22, 35, 8, 6, portions("1 bowl yogurt + berries", "1.5 bowls yogurt + berries", "1 bowl yogurt + berries", "0.75 bowl yogurt + berries"), recipe("5 mins", "0 mins", ["Add yogurt to bowl.", "Top with berries.", "Add seeds.", "Serve chilled."], "Choose unsweetened yogurt.")),
        lunch: createMeal("Veg Biryani with Raita", ["Rice", "Vegetables", "Curd"], 650, 20, 90, 18, 9, portions("1.5 cups biryani + raita", "2 cups biryani + 1 cup raita", "1.5 cups biryani + 0.75 cup raita", "1 cup biryani + 0.5 cup raita"), recipe("15 mins", "30 mins", ["Cook rice.", "Cook vegetables with spices.", "Layer rice and vegetables.", "Serve with raita."], "Use less oil and more vegetables.")),
        eveningSnack: snack,
        dinner: createMeal("Mixed Veg with Dal", ["Vegetables", "Dal", "Roti"], 500, 24, 58, 14, 10, portions("2 rotis + dal + vegetables", "3 rotis + 1.5 cups dal + vegetables", "2 rotis + 1 cup dal + vegetables", "1 roti + 0.5 cup dal + vegetables"), recipe("10 mins", "25 mins", ["Cook dal.", "Cook mixed vegetables.", "Make roti.", "Serve together."], "Balanced home-style dinner."))
      },
      {
        day: "Saturday",
        breakfast: createMeal("Upma", ["Rava", "Vegetables", "Peanuts"], 370, 12, 58, 10, 6, portions("1 bowl upma", "1.5 bowls upma", "1 bowl upma", "0.75 bowl upma"), recipe("8 mins", "15 mins", ["Roast rava.", "Cook vegetables.", "Add water and rava.", "Top with peanuts."], "Add more vegetables for fiber.")),
        lunch: createMeal("Paneer Wrap", ["Paneer", "Whole Wheat Wrap", "Lettuce"], 590, 30, 55, 22, 8, portions("1 paneer wrap", "1.5 wraps", "1 wrap", "0.5 wrap"), recipe("10 mins", "15 mins", ["Cook paneer filling.", "Warm wrap.", "Add lettuce.", "Roll and serve."], "Use whole wheat wrap.")),
        eveningSnack: snack,
        dinner: createMeal("Millet Dosa", ["Millet Batter", "Chutney", "Sambar"], 490, 18, 65, 12, 9, portions("2 dosas + sambar", "3 dosas + 1.5 cups sambar", "2 dosas + 1 cup sambar", "1 dosa + 0.5 cup sambar"), recipe("5 mins", "15 mins", ["Heat pan.", "Spread batter.", "Cook dosa.", "Serve with sambar."], "Millets improve fiber intake."))
      },
      {
        day: "Sunday",
        breakfast: createMeal("Paratha with Curd", ["Wheat Flour", "Curd", "Vegetables"], 420, 16, 60, 13, 7, portions("1 paratha + curd", "2 parathas + 1 cup curd", "1 paratha + 0.75 cup curd", "0.5 paratha + 0.5 cup curd"), recipe("10 mins", "15 mins", ["Prepare dough.", "Stuff vegetables.", "Cook paratha.", "Serve with curd."], "Use less ghee for lighter meal.")),
        lunch: createMeal("Family Thali", ["Dal", "Rice", "Roti", "Vegetables", "Salad"], 700, 30, 95, 18, 14, portions("1 thali", "Large thali: dal, rice, 3 rotis, veg, salad", "Medium thali: dal, rice, 2 rotis, veg, salad", "Small thali: dal, rice, 1 roti, veg"), recipe("20 mins", "40 mins", ["Cook dal.", "Cook rice.", "Make roti.", "Prepare vegetables and salad."], "Keep portions balanced.")),
        eveningSnack: snack,
        dinner: createMeal("Light Lentil Soup", ["Lentils", "Vegetables", "Toast"], 430, 22, 48, 10, 10, portions("1 bowl soup + toast", "1.5 bowls soup + 2 toast", "1 bowl soup + 1 toast", "0.75 bowl soup + 0.5 toast"), recipe("10 mins", "25 mins", ["Cook lentils.", "Add vegetables.", "Simmer soup.", "Serve with toast."], "Light dinner for better digestion."))
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
    const {
      craving,
      dietType,
      goal,
      restrictions
    } = req.body || {};

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
      messages: [
        {
          role: "user",
          content: prompt
        }
      ],
      temperature: 0.7,
      response_format: {
        type: "json_object"
      }
    });

    res.json(
      JSON.parse(
        completion.choices[0].message.content
      )
    );

  } catch (error) {

    console.error(
      "Craving alternative error:",
      error
    );

    res.status(500).json({
      craving: req.body?.craving || "",
      alternatives: []
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
