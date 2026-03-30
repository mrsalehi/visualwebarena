#!/bin/bash
set -e

# ── Site URLs ────────────────────────────────────────────────────────────────
HOSTNAME="${HOSTNAME:-ec2-3-149-119-173.us-east-2.compute.amazonaws.com}"

export DATASET=visualwebarena
export CLASSIFIEDS="http://${HOSTNAME}:9980"
export CLASSIFIEDS_RESET_TOKEN="4b61655535e7ed388f0d40a93600254c"
export SHOPPING="http://${HOSTNAME}:7770"
export REDDIT="http://${HOSTNAME}:9999"
export WIKIPEDIA="http://${HOSTNAME}:8888"
export HOMEPAGE="http://${HOSTNAME}:4399"

# ── Run config ───────────────────────────────────────────────────────────────
TEST_START_IDX="${TEST_START_IDX:-0}"
TEST_END_IDX="${TEST_END_IDX:-10}"
TEST_CONFIG_DIR="${TEST_CONFIG_DIR:-test_classifieds}"
RESULT_DIR="${RESULT_DIR:-/weka/oe-training-default/reza/zero/evoskill-march11/results/run_$(date +%Y%m%d_%H%M%S)}"

PYTHON=/root/.conda/envs/vwa/bin/python

cd /weka/oe-training-default/reza/zero/evoskill-march11/visualwebarena

echo "==> Generating test data..."
$PYTHON scripts/generate_test_data.py

echo "==> Running prepare.sh (auto-login)..."
bash prepare.sh

# echo "==> Starting evaluation (idx ${TEST_START_IDX}-${TEST_END_IDX}, config: ${TEST_CONFIG_DIR})..."
# $PYTHON run.py \
#   --instruction_path agent/prompts/jsons/p_cot_id_actree_3s.json \
#   --test_start_idx "$TEST_START_IDX" \
#   --test_end_idx "$TEST_END_IDX" \
#   --result_dir "$RESULT_DIR" \
#   --test_config_base_dir "config_files/vwa/${TEST_CONFIG_DIR}" \
#   --model GLM-4.7-Flash \
#   --provider openai \
#   --action_set_tag id_accessibility_tree --observation_type accessibility_tree \
#   --max_obs_length 32000 \
#   --skip_captioning

# echo "==> Done. Results in: $RESULT_DIR"
